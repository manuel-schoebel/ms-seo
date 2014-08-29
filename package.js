Package.describe({
  name: "manuelschoebel:ms-seo",
  summary: "Easily config SEO for your routes",
  git: "https://github.com/DerMambo/ms-seo.git",
  version: "0.3.0"
});

Package.onUse(function(api){

  api.versionsFrom('0.9.0');

  api.use(['coffeescript', 'underscore'];

  api.use([
    'jquery',
    'deps',
    'iron:router'
  ], 'client');

  api.addFiles([
    'seo_collection.coffee'
  ]);

  // Client Files
  api.addFiles([
    'seo.coffee'
  ], 'client');

  api.addFiles([
    'seo_publications.coffee'
  ], 'server');
});
