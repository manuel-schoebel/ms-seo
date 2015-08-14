Package.describe({
  name: "manuelschoebel:ms-seo",
  summary: "Easily config SEO for your routes",
  git: "https://github.com/DerMambo/ms-seo.git",
  version: "0.5.0"
});

Package.onUse(function(api){

  api.versionsFrom('1.0');

  api.use(['mongo', 'coffeescript', 'underscore']);

  api.use([
    'jquery',
    'deps'
  ], 'client');
  api.use([
    'iron:router@1.0.0',
    'kadira:flow-router@2.0.0'
  ], 'client', {weak: true});

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
