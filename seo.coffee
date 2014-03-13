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
    twitter: [
      {key: 'title', value: ''}
      {key: 'url', value: ''}
      {key: 'description', value: ''}
    ]
    ignore:
        meta: ['fragment']
  }
  config: (settings) ->
    _.extend(@settings, settings)
  set: (options) ->
    meta = options.meta
    og = options.og
    twitter = options.twitter
    # set meta
    if meta and _.isArray(meta)
      for m in meta
        SEO.setMeta("name='#{m.key}'", m.value)
    else if meta and _.isObject(meta)
      for k, v of meta
        SEO.setMeta("name='#{k}'", v)
    # set og
    if og and _.isArray(og)
      for o in og
        SEO.setMeta("property='og:#{o.key}'", o.value)
    else if og and _.isObject(og)
      for k, v of og
        SEO.setMeta("property='og:#{k}'", v)
    # set twitter
    if twitter and _.isArray(twitter)
      for o in twitter
        SEO.setMeta("property='twitter:#{o.key}'", o.value)
    else if twitter and _.isObject(twitter)
      for k, v of twitter
        SEO.setMeta("property='twitter:#{k}'", v)

    SEO.setTitle options.title if options.title
    SEO.setLink options.rel_author, 'author' if options.rel_author
  clearAll: ->
    for m in $("meta")
      $(m).remove() if _.indexOf(SEO.settings.ignore.meta, $(m).attr('name')) is -1
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
