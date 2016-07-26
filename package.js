Package.describe({
  name: "linguahouse:ms-seo",
  summary: "Easily config SEO for your routes",
  git: "https://github.com/linguahouse/ms-seo.git",
  version: "0.5.0"
});

Package.onUse(function(api){

  api.versionsFrom('1.2');

  api.use(['mongo', 'coffeescript', 'underscore']);

  api.use([
    'jquery',
    'deps',
    'iron:router@1.0.0'
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
