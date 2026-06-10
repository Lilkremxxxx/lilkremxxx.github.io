INSERT INTO blog_posts (
  slug, title, excerpt, cover_image_url, content_markdown, content_html, content_blocks,
  status, language, reading_time_minutes, published_at, seo_title, seo_description
)
VALUES
(
  'welcome-to-my-blog',
  'Welcome to my blog',
  'A short introduction to the blog format, what will live here, and how the editor works.',
  '/assets/blog/welcome-mascot.png',
  '# Welcome to my blog\n\nThis blog is where I publish technical notes, case studies, and project write-ups.',
  '<h2>Welcome to my blog</h2><p>This blog is where I publish technical notes, case studies, and project write-ups.</p>',
  '[
    {"id":"welcome-1","type":"heading","data":{"level":2,"text":"Welcome to my blog"}},
    {"id":"welcome-2","type":"paragraph","data":{"text":"This space collects project notes, engineering decisions, and research summaries. It is written as a living notebook, so articles can mix prose, images, code, and outputs in one place."}},
    {"id":"welcome-2b","type":"paragraph","data":{"text":"The structure of each article follows a paper-like flow: context, method, evidence, implementation detail, and a short reflection on what I would improve next."}},
    {"id":"welcome-3","type":"quote","data":{"text":"A good blog is a changelog for ideas.","cite":"Nguyen Nhat Bang"}},
    {"id":"welcome-4","type":"image","data":{"url":"/assets/blog/welcome-mascot.png","alt":"Portfolio mascot","caption":"The mascot that anchors the portfolio identity."}},
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
  '/assets/blog/stroke-roc-curves.png',
  '# Healthcare Stroke Prediction\n\nThis project merges clinical data, feature synthesis, and threshold-aware classification.',
  '<h2>Healthcare Stroke Prediction</h2><p>This project merges clinical data, feature synthesis, and threshold-aware classification.</p>',
  '[
    {"id":"stroke-1","type":"heading","data":{"level":2,"text":"Healthcare Stroke Prediction"}},
    {"id":"stroke-2","type":"paragraph","data":{"text":"The pipeline starts by collapsing 143,960 visit rows into 5,110 unique patient profiles. That change matters more than the model choice, because it removes patient leakage before any train/test split happens."}},
    {"id":"stroke-2b","type":"paragraph","data":{"text":"Instead of treating the Kaggle-like table as a simple row classification task, the project explicitly models patient identity as the unit of evaluation. That change makes the resulting metrics much closer to deployment reality in a healthcare screening flow."}},
    {"id":"stroke-2c","type":"heading","data":{"level":3,"text":"Method and split design"}},
    {"id":"stroke-2d","type":"paragraph","data":{"text":"A stratified patient-level split preserves the positive ratio across train, validation, and test partitions. Threshold selection is performed only on validation data, then frozen before test evaluation to avoid leakage and to mirror a real operating point."}},
    {"id":"stroke-2e","type":"paragraph","data":{"text":"The calorie regressor is trained on a separate exercise dataset so that Estimated_calories becomes a behavioral proxy instead of a direct clinical measurement. That feature is intentionally synthetic: it adds signal related to metabolic capacity without pretending to replace measured physical activity."}},
    {"id":"stroke-3","type":"image","data":{"url":"/assets/blog/stroke-confusion-matrix.png","alt":"Stroke confusion matrix","caption":"Confusion matrix on the held-out patient test set."}},
    {"id":"stroke-4","type":"image","data":{"url":"/assets/blog/stroke-roc-curves.png","alt":"ROC curves for stroke models","caption":"ROC curves for six classifiers, with XGBoost selected as the best performer."}},
    {"id":"stroke-4b","type":"heading","data":{"level":3,"text":"Feature interpretation"}},
    {"id":"stroke-4c","type":"paragraph","data":{"text":"SHAP analysis places age and average glucose level at the top of the ranking, which aligns with the clinical intuition that metabolic stress and demographic risk matter. The synthetic calories feature is added as a behavioral proxy, not as a replacement for direct exercise measurement."}},
    {"id":"stroke-4d","type":"table","data":{"title":"Table I. Classifier performance on the deduplicated test set","headers":["Model","Thresh.","Acc.","Prec.","Recall","F1","AUC"],"rows":[["Grad. Boost.","0.080","83.6%","19.0%","71.1%","0.300","0.857"],["Log. Reg.","0.605","81.2%","17.7%","76.3%","0.287","0.859"],["XGBoost","0.585","79.5%","17.1%","81.6%","0.283","0.863"],["Rand. Forest","0.570","81.7%","17.3%","71.1%","0.278","0.853"],["Extra Trees","0.570","80.3%","17.0%","76.3%","0.278","0.848"],["Hist. GB","0.655","84.4%","16.9%","55.3%","0.259","0.858"]]}},
    {"id":"stroke-5","type":"image","data":{"url":"/assets/blog/stroke-shap-bar.png","alt":"SHAP summary bar chart","caption":"SHAP feature importance summary."}},
    {"id":"stroke-6","type":"image","data":{"url":"/assets/blog/stroke-shap-beeswarm.png","alt":"SHAP beeswarm plot","caption":"SHAP directionality check on the final feature set."}},
    {"id":"stroke-6b","type":"heading","data":{"level":3,"text":"Experimental results"}},
    {"id":"stroke-6c","type":"paragraph","data":{"text":"The comparison across Logistic Regression, Random Forest, Extra Trees, Gradient Boosting, Histogram Gradient Boosting, and XGBoost shows that the best model depends on the objective. If the goal is F1 optimization under threshold control, Gradient Boosting leads. If the goal is ranking quality and recall for screening, XGBoost provides the strongest tradeoff."}},
    {"id":"stroke-6d","type":"table","data":{"title":"Table II. Anomalous feature Pearson correlations with stroke_target","headers":["Feature","r (Pearson)","Mean (No stroke)","Mean (Stroke)"],"rows":[["avg_ap_hi","-0.030","126.35","124.59"],["avg_ap_lo","-0.030","97.29","86.46"],["heart_cholesterol","-0.045","218.79","207.12"],["bmi (raw)","-0.052","27.87","25.58"]]}},
    {"id":"stroke-6e","type":"table","data":{"title":"Table III. Feature ablation study","headers":["Feature Variant","Accuracy","F1","AUC-ROC"],"rows":[["All features","93.4%","0.243","0.740"],["Drop avg_weight, avg_height","93.4%","0.243","0.740"],["Drop bmi, keep wt/ht","91.4%","0.212","0.695"],["Drop body size, keep bmi","93.7%","0.133","0.732"]]}},
    {"id":"stroke-7","type":"code","data":{"language":"bash","code":"python Code/Model.py\\npython Code/compare_models.py\\npython Code/evaluate_model.py\\npython Code/generate_figures.py"}},
    {"id":"stroke-8","type":"paragraph","data":{"text":"The implementation is deliberately simple to reproduce: the workflow builds artifacts, compares candidate classifiers, evaluates the final model, and exports the figures needed for paper submission."}},
    {"id":"stroke-8b","type":"heading","data":{"level":3,"text":"Discussion and deployment"}},
    {"id":"stroke-8c","type":"paragraph","data":{"text":"The C++ deployment path matters because it removes Python runtime dependency and makes the pipeline suitable for lightweight screening tools. The paper argues that the correct tradeoff is not pure model complexity but repeatable, low-latency inference with explicit threshold selection."}},
    {"id":"stroke-9","type":"quote","data":{"text":"XGBoost achieved the highest AUC-ROC of 0.8630 and recall of 81.58% on the held-out patient test set.","cite":"Final paper"}}
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
  '/assets/blog/lung-fig-architecture.png',
  '# Lung Cancer AFF + C++ Inference\n\nThis project blends explainable image features with edge deployment.',
  '<h2>Lung Cancer AFF + C++ Inference</h2><p>This project blends explainable image features with edge deployment.</p>',
  '[
    {"id":"lung-1","type":"heading","data":{"level":2,"text":"Lung Cancer AFF + C++ Inference"}},
    {"id":"lung-2","type":"paragraph","data":{"text":"The model combines an InceptionV3 backbone, multi-scale attention, handcrafted GLCM/LBP texture features, and an Attentional Feature Fusion module. The result is not only accurate, but also easier to explain to clinicians."}},
    {"id":"lung-2b","type":"paragraph","data":{"text":"The key design decision is not just to stack deep and handcrafted features, but to let the network learn how much to trust each branch for each image. That gives the classifier a better shot at handling different scan appearances without losing interpretability."}},
    {"id":"lung-2c","type":"heading","data":{"level":3,"text":"Preprocessing and feature fusion"}},
    {"id":"lung-2d","type":"paragraph","data":{"text":"The images are denoised, resized, and normalized before feature extraction. GLCM captures textural co-occurrence, LBP encodes local structure, and the deep branch learns abstract cues from InceptionV3. AFF then weights the two streams rather than flattening them into a naive concatenation."}},
    {"id":"lung-2e","type":"paragraph","data":{"text":"The paper formalizes this with a lightweight adaptive denoising equation and a bottleneck fusion rule. The goal is to keep the math readable enough for a report while still matching the logic of the implemented pipeline."}},
    {"id":"lung-3","type":"image","data":{"url":"/assets/blog/lung-fig-architecture.png","alt":"Hybrid architecture","caption":"Overall architecture of the hybrid explainable lung cancer framework."}},
    {"id":"lung-4","type":"image","data":{"url":"/assets/blog/lung-test-ct.png","alt":"Test CT input","caption":"Example CT input used by the C++ inference demo."}},
    {"id":"lung-5","type":"image","data":{"url":"/assets/blog/lung-confusion-matrix.png","alt":"Lung cancer confusion matrix","caption":"Cross-validation confusion matrix from the paper."}},
    {"id":"lung-6","type":"image","data":{"url":"/assets/blog/lung-roc-curves.png","alt":"Lung cancer ROC curves","caption":"ROC curves for the three-class classifier."}},
    {"id":"lung-7","type":"image","data":{"url":"/assets/blog/lung-ext-prediction.png","alt":"External prediction distribution","caption":"External dataset prediction distribution for robustness checks."}},
    {"id":"lung-7b","type":"heading","data":{"level":3,"text":"Edge deployment"}},
    {"id":"lung-7c","type":"paragraph","data":{"text":"The project is exported to ONNX and replayed in C++ with ONNX Runtime and OpenCV. That matters because it shows the pipeline can leave the notebook and survive in a lower-dependency runtime where performance and portability matter."}},
    {"id":"lung-7d","type":"paragraph","data":{"text":"The results section highlights not only aggregate accuracy and ROC-AUC, but also per-class precision/recall/F1, class distribution, and preprocessing robustness. That gives the article the same scientific shape as the source paper."}},
    {"id":"lung-7e","type":"table","data":{"title":"Table I. IQ-OTHNCCD dataset statistics","headers":["Class","Number of Images","Percentage"],"rows":[["Benign","120","10.94%"],["Malignant","561","51.14%"],["Normal","416","37.92%"],["Total","1,097","100.00%"]]}},
    {"id":"lung-7f","type":"table","data":{"title":"Table II. Per-class validation metrics (5-fold CV)","headers":["Class","Precision","Recall","F1-Score","Support"],"rows":[["Benign","0.9735","0.9167","0.9442","120"],["Malignant","0.9947","0.9947","0.9947","561"],["Normal","0.9716","0.9880","0.9797","416"],["Weighted Avg","0.9841","0.9836","0.9835","1,097"]]}},
    {"id":"lung-7g","type":"table","data":{"title":"Table III. Comparison with existing methods","headers":["Method","Dataset","Accuracy (%)","AUC"],"rows":[["VGG16 + SVM [17]","IQ-OTHNCCD","94.50","0.9520"],["ResNet50 [18]","IQ-OTHNCCD","96.20","0.9710"],["DenseNet121 [18]","IQ-OTHNCCD","95.80","0.9680"],["EfficientNet-B0 [19]","IQ-OTHNCCD","97.30","0.9850"],["InceptionV3 + GLCM [9]","IQ-OTHNCCD","98.10","0.9910"],["Proposed (AFF + MSCA)","IQ-OTHNCCD","98.36","0.9967"]]}},
    {"id":"lung-7h","type":"table","data":{"title":"Table IV. C++ edge deployment characteristics","headers":["Metric","Value"],"rows":[["ONNX Model Size","45.3 MB"],["Runtime","ONNX Runtime 1.26.0"],["Compiler","MSVC 19.51 (C++17)"],["Feature Precision Match","< 10^-5 (all 58 features)"],["Prediction Agreement","100% identical to Python"]]}},
    {"id":"lung-8","type":"code","data":{"language":"cpp","code":"string imagePath = \\\"test_ct.png\\\";\\nmean = loadNpyVector(\\\"glcm_lbp_mean.npy\\\");\\nstd_dev = loadNpyVector(\\\"glcm_lbp_std.npy\\\");\\ncout << \\\"Da load thanh cong model.onnx!\\\" << endl;"}},
    {"id":"lung-9","type":"paragraph","data":{"text":"The final validation story is about consistency: model predictions, heatmaps, and C++ inference output are aligned so the system can be reasoned about as one pipeline rather than a collection of disconnected scripts."}},
    {"id":"lung-10","type":"quote","data":{"text":"The entire pipeline is exported to ONNX format and deployed through a high-performance C++ inference engine using ONNX Runtime and OpenCV.","cite":"Final paper"}}
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
