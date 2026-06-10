import cors from 'cors';
import express from 'express';
import { Pool } from 'pg';

const app = express();
const adminApiKey = process.env.ADMIN_API_KEY || '';
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.PGSSL === 'true' ? { rejectUnauthorized: false } : undefined
});

const toTagSlug = (tagName) =>
  tagName
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');

const normalizeTags = (tags) =>
  (Array.isArray(tags) ? tags : [])
    .map((tag) => String(tag).trim())
    .filter(Boolean);

const normalizePost = (row) => ({
  id: row.id,
  slug: row.slug,
  title: row.title,
  excerpt: row.excerpt,
  coverImageUrl: row.cover_image_url,
  contentMarkdown: row.content_markdown,
  contentHtml: row.content_html,
  status: row.status,
  language: row.language,
  readingTimeMinutes: row.reading_time_minutes,
  publishedAt: row.published_at,
  seoTitle: row.seo_title,
  seoDescription: row.seo_description,
  tags: Array.isArray(row.tags)
    ? row.tags
    : typeof row.tags === 'string' && row.tags.length
      ? JSON.parse(row.tags)
      : []
});

async function syncPostTags(client, postId, tagNames) {
  await client.query('DELETE FROM blog_post_tags WHERE post_id = $1', [postId]);

  const uniqueTagNames = [...new Set(normalizeTags(tagNames))];

  for (const tagName of uniqueTagNames) {
    const slug = toTagSlug(tagName);
    if (!slug) continue;

    const tagRow = await client.query(
      `
        INSERT INTO blog_tags (slug, name)
        VALUES ($1, $2)
        ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name
        RETURNING id
      `,
      [slug, tagName]
    );

    await client.query(
      `
        INSERT INTO blog_post_tags (post_id, tag_id)
        VALUES ($1, $2)
        ON CONFLICT DO NOTHING
      `,
      [postId, tagRow.rows[0].id]
    );
  }
}

async function fetchPostBySlug(client, slug) {
  const { rows } = await client.query(
    `
      SELECT
        p.*,
        COALESCE(
          json_agg(t.name ORDER BY t.name) FILTER (WHERE t.name IS NOT NULL),
          '[]'
        ) AS tags
      FROM blog_posts p
      LEFT JOIN blog_post_tags pt ON pt.post_id = p.id
      LEFT JOIN blog_tags t ON t.id = pt.tag_id
      WHERE p.slug = $1
      GROUP BY p.id
      LIMIT 1
    `,
    [slug]
  );

  return rows[0] || null;
}

async function rollbackAndFail(client, res, error) {
  try {
    await client.query('ROLLBACK');
  } catch (_rollbackError) {
    // Ignore rollback failures so the original error can still be reported.
  }

  console.error(error);
  res.status(500).json({ error: 'Database operation failed' });
}

const requireAdminKey = (req, res, next) => {
  if (!adminApiKey) return next();
  if (req.header('x-admin-key') !== adminApiKey) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  next();
};

app.use(cors());
app.use(express.json({ limit: '2mb' }));

app.get('/api/health', async (_req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ ok: false, error: 'Database connection failed' });
  }
});

app.get('/api/blog/posts', async (req, res) => {
  const limit = Math.min(Number(req.query.limit || 20), 100);
  const offset = Math.max(Number(req.query.offset || 0), 0);
  const status = req.query.status || 'published';

  const { rows } = await pool.query(
    `
      SELECT
        p.*,
        COALESCE(
          json_agg(t.name ORDER BY t.name) FILTER (WHERE t.name IS NOT NULL),
          '[]'
        ) AS tags
      FROM blog_posts p
      LEFT JOIN blog_post_tags pt ON pt.post_id = p.id
      LEFT JOIN blog_tags t ON t.id = pt.tag_id
      WHERE p.status = $1
      GROUP BY p.id
      ORDER BY p.published_at DESC NULLS LAST, p.created_at DESC
      LIMIT $2 OFFSET $3
    `,
    [status, limit, offset]
  );

  res.json({ items: rows.map(normalizePost), limit, offset });
});

app.get('/api/blog/posts/:slug', async (req, res) => {
  const row = await fetchPostBySlug(pool, req.params.slug);

  if (!row) {
    return res.status(404).json({ error: 'Post not found' });
  }

  res.json({ item: normalizePost(row) });
});

app.post('/api/blog/posts', requireAdminKey, async (req, res) => {
  const {
    slug,
    title,
    excerpt = '',
    coverImageUrl = null,
    contentMarkdown = '',
    contentHtml = '',
    status = 'draft',
    language = 'en',
    readingTimeMinutes = 1,
    publishedAt = null,
    seoTitle = null,
    seoDescription = null,
    tags = []
  } = req.body || {};

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const insertResult = await client.query(
      `
        INSERT INTO blog_posts (
          slug, title, excerpt, cover_image_url, content_markdown, content_html,
          status, language, reading_time_minutes, published_at, seo_title, seo_description
        )
        VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)
        RETURNING id, slug
      `,
      [slug, title, excerpt, coverImageUrl, contentMarkdown, contentHtml, status, language, readingTimeMinutes, publishedAt, seoTitle, seoDescription]
    );

    await syncPostTags(client, insertResult.rows[0].id, tags);

    const row = await fetchPostBySlug(client, insertResult.rows[0].slug);
    await client.query('COMMIT');

    res.status(201).json({ item: normalizePost(row) });
  } catch (error) {
    await rollbackAndFail(client, res, error);
  } finally {
    client.release();
  }
});

app.put('/api/blog/posts/:slug', requireAdminKey, async (req, res) => {
  const {
    title,
    excerpt = '',
    coverImageUrl = null,
    contentMarkdown = '',
    contentHtml = '',
    status = 'draft',
    language = 'en',
    readingTimeMinutes = 1,
    publishedAt = null,
    seoTitle = null,
    seoDescription = null,
    tags = []
  } = req.body || {};

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const updateResult = await client.query(
      `
        UPDATE blog_posts
        SET title = $2,
            excerpt = $3,
            cover_image_url = $4,
            content_markdown = $5,
            content_html = $6,
            status = $7,
            language = $8,
            reading_time_minutes = $9,
            published_at = $10,
            seo_title = $11,
            seo_description = $12
        WHERE slug = $1
        RETURNING id, slug
      `,
      [req.params.slug, title, excerpt, coverImageUrl, contentMarkdown, contentHtml, status, language, readingTimeMinutes, publishedAt, seoTitle, seoDescription]
    );

    if (!updateResult.rows.length) {
      await client.query('ROLLBACK');
      return res.status(404).json({ error: 'Post not found' });
    }

    await syncPostTags(client, updateResult.rows[0].id, tags);

    const row = await fetchPostBySlug(client, updateResult.rows[0].slug);
    await client.query('COMMIT');

    res.json({ item: normalizePost(row) });
  } catch (error) {
    await rollbackAndFail(client, res, error);
  } finally {
    client.release();
  }
});

app.delete('/api/blog/posts/:slug', requireAdminKey, async (req, res) => {
  const result = await pool.query('DELETE FROM blog_posts WHERE slug = $1 RETURNING id', [req.params.slug]);
  if (!result.rowCount) return res.status(404).json({ error: 'Post not found' });
  res.status(204).end();
});

export default app;
