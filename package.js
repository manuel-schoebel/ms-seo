Package.describe({
  name: "manuelschoebel:ms-seo",
  summary: "Easily config SEO for your routes",
  git: "https://github.com/DerMambo/ms-seo.git",
  version: "0.4.1"
});

Package.onUse(function(api){

  api.versionsFrom('1.0');

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
