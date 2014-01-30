SEO =
  settings: {
    title: ''
    rel_author: ''
    meta: [
      {key: 'description', value: ''}
    ]
    og: [
      {key: 'title', value: ''}
      {key: 'url', value: ''}
      {key: 'image', value: ''}
    ]
  }
  config: (settings) ->
    _.extend(@settings, settings)
  set: (options) ->
    if options.meta
      for m in options.meta
        SEO.setMeta("name='#{m.key}'", m.value)
    if options.og
      for o in options.og
        SEO.setMeta("property='og:#{o.key}'", o.value)
    SEO.setTitle options.title if options.title
    SEO.setLink options.rel_author, 'author' if options.rel_author
  clearAll: ->
    $("meta").remove()
    @set(@settings)
    @setTitle(@settings.title)
  setTitle: (title) ->
    document.title = title
  setLink: (href, rel) ->
    if $("link[rel=#{rel}]").length is 0
      $('head').append("<link href='#{href}' rel='#{rel}'>")
    else
      if href
        $("link[rel='#{rel}']").attr('href', href)
      else
        $("link[rel='#{rel}']").remove()
  setMeta: (attr, content) ->
    if $("meta[#{attr}]").length is 0
      if content
        $('head').append("<meta #{attr} content='#{content}'>")
    else
      if content
        $("meta[#{attr}]").attr('content', content)
      else
        $("meta[#{attr}]").remove()

@SEO = SEO

# IR before hooks
Router.before -> SEO.clearAll()

getCurrentRouteName = ->
  router = Router.current()
  return unless router
  routeName = router.route.name
  return routeName

# Get seo settings depending on route
Deps.autorun( ->
  currentRouteName = getCurrentRouteName()
  return unless currentRouteName
  Meteor.subscribe('seoByRouteName', currentRouteName)
)

# Set seo settings depending on route
Deps.autorun( ->
  return unless SEO
  currentRouteName = getCurrentRouteName()
  settings = SeoCollection.findOne({route_name: currentRouteName}) or {}
  SEO.set(settings)
)