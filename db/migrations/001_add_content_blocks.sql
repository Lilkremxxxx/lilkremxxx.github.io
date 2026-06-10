ALTER TABLE IF EXISTS blog_posts
  ADD COLUMN IF NOT EXISTS content_blocks JSONB NOT NULL DEFAULT '[]'::jsonb;

UPDATE blog_posts
SET content_blocks = '[]'::jsonb
WHERE content_blocks IS NULL;
