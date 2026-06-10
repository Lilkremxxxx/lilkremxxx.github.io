INSERT INTO blog_posts (slug, title, excerpt, cover_image_url, content_markdown, content_html, status, language, reading_time_minutes, published_at, seo_title, seo_description)
VALUES
(
  'blog-ai-portfolio',
  'Blog - AI Portfolio',
  'Landing page for the blog hub with a clean editorial layout and strong visual hierarchy.',
  NULL,
  '# Blog - AI Portfolio\n\nThis is the blog landing page.',
  '<p>This is the blog landing page.</p>',
  'published',
  'en',
  2,
  NOW(),
  'Blog - AI Portfolio',
  'Editorial blog landing page for the AI portfolio.'
)
ON CONFLICT (slug) DO UPDATE
SET title = EXCLUDED.title,
    excerpt = EXCLUDED.excerpt,
    content_markdown = EXCLUDED.content_markdown,
    content_html = EXCLUDED.content_html,
    status = EXCLUDED.status,
    language = EXCLUDED.language,
    reading_time_minutes = EXCLUDED.reading_time_minutes,
    published_at = EXCLUDED.published_at,
    seo_title = EXCLUDED.seo_title,
    seo_description = EXCLUDED.seo_description,
    updated_at = NOW();

INSERT INTO blog_posts (slug, title, excerpt, cover_image_url, content_markdown, content_html, status, language, reading_time_minutes, published_at, seo_title, seo_description)
VALUES
(
  'deep-dive-neural-architectures-refined-point-cloud',
  'Deep Dive: Neural Architectures (Refined Point Cloud) - Blog',
  'A long-form article slot for the flagship technical piece from Stitch.',
  NULL,
  '# Deep Dive: Neural Architectures\n\nThis is the detailed article page.',
  '<p>This is the detailed article page.</p>',
  'published',
  'en',
  8,
  NOW(),
  'Deep Dive: Neural Architectures',
  'Deep technical article page for the AI portfolio blog.'
)
ON CONFLICT (slug) DO UPDATE
SET title = EXCLUDED.title,
    excerpt = EXCLUDED.excerpt,
    content_markdown = EXCLUDED.content_markdown,
    content_html = EXCLUDED.content_html,
    status = EXCLUDED.status,
    language = EXCLUDED.language,
    reading_time_minutes = EXCLUDED.reading_time_minutes,
    published_at = EXCLUDED.published_at,
    seo_title = EXCLUDED.seo_title,
    seo_description = EXCLUDED.seo_description,
    updated_at = NOW();

INSERT INTO blog_tags (slug, name)
VALUES
('ai-engineering', 'AI Engineering'),
('llm-systems', 'LLM Systems'),
('research-notes', 'Research Notes')
ON CONFLICT (slug) DO NOTHING;
