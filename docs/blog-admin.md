# Blog Admin

## Local setup

1. Copy `.env.example` to `.env`.
2. Set `DATABASE_URL=postgresql://cloud:cloud_pass@100.82.138.69:5432/nhatbang-web`.
3. Set `PORT=8787`.
4. Set `ADMIN_API_KEY=lilkremxxx-admin-dev-2026`.
5. Set `BLOG_PUBLIC_API_BASE=https://blog-api.verbaa.pp.ua`.
6. Install dependencies with `npm install`.
7. Apply the schema with `npm run db:schema`.
8. Load the seed data with `npm run db:seed`.
9. Start the API with `npm run dev:api`.

## Admin usage

1. Open the site at `http://localhost:8787/admin/blog`.
2. In the browser console, set the admin key with:

```js
localStorage.setItem('blog_admin_key', 'lilkremxxx-admin-dev-2026')
```

3. Refresh the page so the admin list loads with the key attached.
4. Use the form to create a post, or select an existing post from the list to edit it.
5. Save the post, then confirm the list refreshes and the public blog view shows the updated content.
