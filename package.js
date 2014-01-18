Package.describe({
  summary: "A blog system for meteor"
});

Package.on_use(function(api){
  var both = ['client', 'server'];

  api.use([
    'coffeescript',
    'jquery'
  ], 'client');

  // Client Files
  api.add_files([
    'seo.coffee'
  ], 'client');
});