Package.describe({
  summary: "A blog system for meteor"
});

Package.on_use(function(api){
  var both = ['client', 'server'];

  api.use(['coffeescript'], both);

  api.use([
    'jquery',
    'deps',
    'iron-router'
  ], 'client');

  api.add_files([
    'seo_collection.coffee'
  ], both);

  // Client Files
  api.add_files([
    'seo.coffee'
  ], 'client');

  api.add_files([
    'seo_publications.coffee'
  ], 'server');
});