Meteor.publish 'seoByRouteName', (routeName) ->
  check(routeName, String)
  return SeoCollection.find({route_name: routeName})