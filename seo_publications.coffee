Meteor.publish 'seoByRouteName', (routeName) ->
  return SeoCollection.find({route_name: routeName})