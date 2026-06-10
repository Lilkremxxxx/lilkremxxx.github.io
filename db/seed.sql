INSERT INTO blog_posts (
  slug, title, excerpt, cover_image_url, content_markdown, content_html, content_blocks,
  status, language, reading_time_minutes, published_at, seo_title, seo_description
)
VALUES
(
  'welcome-to-my-blog',
  'Welcome to my blog',
  'A short introduction to the blog format, what will live here, and how the editor works.',
  '/mascot_transparent.png',
  '# Welcome to my blog\n\nThis blog is where I publish technical notes, case studies, and project write-ups.',
  '<h2>Welcome to my blog</h2><p>This blog is where I publish technical notes, case studies, and project write-ups.</p>',
  '[
    {"id":"welcome-1","type":"heading","data":{"level":2,"text":"Welcome to my blog"}},
    {"id":"welcome-2","type":"paragraph","data":{"text":"This space collects project notes, engineering decisions, and research summaries. It is written as a living notebook, so articles can mix prose, images, code, and outputs in one place."}},
    {"id":"welcome-3","type":"quote","data":{"text":"A good blog is a changelog for ideas.","cite":"Nguyen Nhat Bang"}},
    {"id":"welcome-4","type":"image","data":{"url":"/mascot_transparent.png","alt":"Portfolio mascot","caption":"The mascot that anchors the portfolio identity."}},
    {"id":"welcome-5","type":"paragraph","data":{"text":"In the next posts I will share two capstone-style case studies: a stroke risk prediction pipeline and a lung cancer classification system. Both posts pull directly from the project folders inside this repo."}},
    {"id":"welcome-6","type":"link","data":{"label":"Browse the public blog","url":"/blog"}}
  ]'::jsonb,
  'published',
  'en',
  2,
  NOW(),
  'Welcome to my blog',
  'An introduction to the portfolio blog and what will be published here.'
)
ON CONFLICT (slug) DO UPDATE
SET title = EXCLUDED.title,
    excerpt = EXCLUDED.excerpt,
    cover_image_url = EXCLUDED.cover_image_url,
    content_markdown = EXCLUDED.content_markdown,
    content_html = EXCLUDED.content_html,
    content_blocks = EXCLUDED.content_blocks,
    status = EXCLUDED.status,
    language = EXCLUDED.language,
    reading_time_minutes = EXCLUDED.reading_time_minutes,
    published_at = EXCLUDED.published_at,
    seo_title = EXCLUDED.seo_title,
    seo_description = EXCLUDED.seo_description,
    updated_at = NOW();

INSERT INTO blog_posts (
  slug, title, excerpt, cover_image_url, content_markdown, content_html, content_blocks,
  status, language, reading_time_minutes, published_at, seo_title, seo_description
)
VALUES
(
  'healthcare-stroke-prediction',
  'Healthcare Stroke Prediction',
  'A patient-level stroke risk pipeline with deduplication, SHAP analysis, and synthetic energy expenditure features.',
  '/Project/Healthcare-Stroke-prediction/artifacts/roc_curves.png',
  '# Healthcare Stroke Prediction\n\nThis project merges clinical data, feature synthesis, and threshold-aware classification.',
  '<h2>Healthcare Stroke Prediction</h2><p>This project merges clinical data, feature synthesis, and threshold-aware classification.</p>',
  '[
    {"id":"stroke-1","type":"heading","data":{"level":2,"text":"Healthcare Stroke Prediction"}},
    {"id":"stroke-2","type":"paragraph","data":{"text":"The pipeline starts by collapsing 143,960 visit rows into 5,110 unique patient profiles. That change matters more than the model choice, because it removes patient leakage before any train/test split happens."}},
    {"id":"stroke-3","type":"image","data":{"url":"/Project/Healthcare-Stroke-prediction/artifacts/confusion_matrix.png","alt":"Stroke confusion matrix","caption":"Confusion matrix on the held-out patient test set."}},
    {"id":"stroke-4","type":"image","data":{"url":"/Project/Healthcare-Stroke-prediction/artifacts/roc_curves.png","alt":"ROC curves for stroke models","caption":"ROC curves for six classifiers, with XGBoost selected as the best performer."}},
    {"id":"stroke-5","type":"image","data":{"url":"/Project/Healthcare-Stroke-prediction/artifacts/shap_summary_bar.png","alt":"SHAP summary bar chart","caption":"SHAP feature importance summary."}},
    {"id":"stroke-6","type":"image","data":{"url":"/Project/Healthcare-Stroke-prediction/artifacts/shap_summary_beeswarm.png","alt":"SHAP beeswarm plot","caption":"SHAP directionality check on the final feature set."}},
    {"id":"stroke-7","type":"code","data":{"language":"bash","code":"python Code/Model.py\\npython Code/compare_models.py\\npython Code/evaluate_model.py\\npython Code/generate_figures.py"}},
    {"id":"stroke-8","type":"quote","data":{"text":"XGBoost achieved the highest AUC-ROC of 0.8630 and recall of 81.58% on the held-out patient test set.","cite":"Final paper"}}
  ]'::jsonb,
  'published',
  'en',
  8,
  NOW(),
  'Healthcare Stroke Prediction',
  'A technical case study on stroke risk prediction with deduplication and SHAP.'
)
ON CONFLICT (slug) DO UPDATE
SET title = EXCLUDED.title,
    excerpt = EXCLUDED.excerpt,
    cover_image_url = EXCLUDED.cover_image_url,
    content_markdown = EXCLUDED.content_markdown,
    content_html = EXCLUDED.content_html,
    content_blocks = EXCLUDED.content_blocks,
    status = EXCLUDED.status,
    language = EXCLUDED.language,
    reading_time_minutes = EXCLUDED.reading_time_minutes,
    published_at = EXCLUDED.published_at,
    seo_title = EXCLUDED.seo_title,
    seo_description = EXCLUDED.seo_description,
    updated_at = NOW();

INSERT INTO blog_posts (
  slug, title, excerpt, cover_image_url, content_markdown, content_html, content_blocks,
  status, language, reading_time_minutes, published_at, seo_title, seo_description
)
VALUES
(
  'lung-cancer-aff-cpp-inference',
  'Lung Cancer AFF + C++ Inference',
  'A hybrid CT classification system that fuses deep features, handcrafted texture descriptors, and ONNX Runtime C++ deployment.',
  '/Project/Lung_cancer/Paper_Docs/paper_figures/fig_architecture.png',
  '# Lung Cancer AFF + C++ Inference\n\nThis project blends explainable image features with edge deployment.',
  '<h2>Lung Cancer AFF + C++ Inference</h2><p>This project blends explainable image features with edge deployment.</p>',
  '[
    {"id":"lung-1","type":"heading","data":{"level":2,"text":"Lung Cancer AFF + C++ Inference"}},
    {"id":"lung-2","type":"paragraph","data":{"text":"The model combines an InceptionV3 backbone, multi-scale attention, handcrafted GLCM/LBP texture features, and an Attentional Feature Fusion module. The result is not only accurate, but also easier to explain to clinicians."}},
    {"id":"lung-3","type":"image","data":{"url":"/Project/Lung_cancer/Paper_Docs/paper_figures/fig_architecture.png","alt":"Hybrid architecture","caption":"Overall architecture of the hybrid explainable lung cancer framework."}},
    {"id":"lung-4","type":"image","data":{"url":"/Project/Lung_cancer/Model_Interface/test_ct.png","alt":"Test CT input","caption":"Example CT input used by the C++ inference demo."}},
    {"id":"lung-5","type":"image","data":{"url":"/Project/Lung_cancer/Paper_Docs/paper_figures/fig_confusion_matrix.png","alt":"Lung cancer confusion matrix","caption":"Cross-validation confusion matrix from the paper."}},
    {"id":"lung-6","type":"image","data":{"url":"/Project/Lung_cancer/Paper_Docs/paper_figures/fig_roc_curves.png","alt":"Lung cancer ROC curves","caption":"ROC curves for the three-class classifier."}},
    {"id":"lung-7","type":"image","data":{"url":"/Project/Lung_cancer/Paper_Docs/paper_figures/fig_ext_prediction_dist.png","alt":"External prediction distribution","caption":"External dataset prediction distribution for robustness checks."}},
    {"id":"lung-8","type":"code","data":{"language":"cpp","code":"string imagePath = \\\"test_ct.png\\\";\\nmean = loadNpyVector(\\\"glcm_lbp_mean.npy\\\");\\nstd_dev = loadNpyVector(\\\"glcm_lbp_std.npy\\\");\\ncout << \\\"Da load thanh cong model.onnx!\\\" << endl;"}},
    {"id":"lung-9","type":"quote","data":{"text":"The entire pipeline is exported to ONNX format and deployed through a high-performance C++ inference engine using ONNX Runtime and OpenCV.","cite":"Final paper"}}
  ]'::jsonb,
  'published',
  'en',
  9,
  NOW(),
  'Lung Cancer AFF + C++ Inference',
  'Explainable lung cancer classification with feature fusion and edge deployment.'
)
ON CONFLICT (slug) DO UPDATE
SET title = EXCLUDED.title,
    excerpt = EXCLUDED.excerpt,
    cover_image_url = EXCLUDED.cover_image_url,
    content_markdown = EXCLUDED.content_markdown,
    content_html = EXCLUDED.content_html,
    content_blocks = EXCLUDED.content_blocks,
    status = EXCLUDED.status,
    language = EXCLUDED.language,
    reading_time_minutes = EXCLUDED.reading_time_minutes,
    published_at = EXCLUDED.published_at,
    seo_title = EXCLUDED.seo_title,
    seo_description = EXCLUDED.seo_description,
    updated_at = NOW();

INSERT INTO blog_tags (slug, name)
VALUES
('portfolio', 'Portfolio'),
('research-notes', 'Research Notes'),
('medical-ai', 'Medical AI'),
('computer-vision', 'Computer Vision'),
('cpp-inference', 'C++ Inference')
ON CONFLICT (slug) DO NOTHING;
