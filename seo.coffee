@SEO =
  settings: {
    title: ''
    rel_author: ''
    meta: []
    og: []
    twitter: []
    ignore:
      meta: ['fragment']
      link: ['stylesheet']
    auto:
      twitter: true
      og: true
      set: ['description', 'url', 'title']
    # if to use seo route settings from collection
    use_collection: false
  }

  # e.g. ignore('meta', 'fragment')
  ignore: (type, value) ->
    @settings.ignore[type].push(value) if @settings.ignore[type] and _.indexOf(@settings.ignore[type], value) is -1

  # storage of deps handles
  deps: []

  config: (settings) ->
    self = @
    _.extend(@settings, settings)

    if @settings.use_collection is true
      # Get seo settings depending on route
      @deps.push Deps.autorun( ->
        currentRouteName = self.getCurrentRouteName()
        return unless currentRouteName
        Meteor.subscribe('seoByRouteName', currentRouteName)
      )

      # Set seo settings depending on route
      @deps.push Deps.autorun( ->
        return unless SEO
        currentRouteName = self.getCurrentRouteName()
        settings = SeoCollection.findOne({route_name: currentRouteName}) or {}
        SEO.set(settings)
      )

    else if @deps.length
      # stop all deps
      _.each @deps, (handle) ->
        handle?.stop()
      @deps = []

  set: (options, clearBefore=true) ->
    @clearAll() if clearBefore

    currentRouter = Router.current()
    url = Router.url(currentRouter.route.name, currentRouter.params) if currentRouter
    #SEO.set({url: Router.url(currentRouter.route.name, currentRouter.params)})

    meta = options.meta
    og = options.og
    link = options.link
    twitter = options.twitter

    @setTitle options.title if options.title
    @setUrl options.url if options.url

    # set meta
    if meta and _.isArray(meta)
      for m in meta
        @setMeta("name='#{m.key}'", m.value)
    else if meta and _.isObject(meta)
      for k, v of meta
        @setMeta("name='#{k}'", v)

    # set og
    if og and _.isArray(og)
      for o in og
        @setMeta("property='og:#{o.key}'", o.value)
    else if og and _.isObject(og)
      for k, v of og
        @setMeta("property='og:#{k}'", v)

    # set link
    # as array {href: "...", rel: "..."}
    # or as object {rel: href}
    if link and _.isArray(link)
      for l in link
        @setLink(l.rel, l.href)
    else if link and _.isObject(link)
      for k, v of link
        @setLink(k, v)

    # set twitter
    if twitter and _.isArray(twitter)
      for o in twitter
        @setMeta("property='twitter:#{o.key}'", o.value)
    else if twitter and _.isObject(twitter)
      for k, v of twitter
        @setMeta("property='twitter:#{k}'", v)

    # set google+ rel author
    @setLink 'author', options.rel_author if options.rel_author

  clearAll: ->
    for m in $("meta")
      $m = $(m)
      # do not remove anything you do not control
      # MS Seo only sets metas with a name or property
      # Probably not the best solution
      controlled = $m.attr('name') or $m.attr('property')
      ignored = false
      if $m.attr('name') and _.indexOf(SEO.settings.ignore.meta, $m.attr('name')) > -1
        ignored = true
      else if $m.attr('property') and _.indexOf(SEO.settings.ignore.meta, $m.attr('property')) > -1
        ignored = true
      if not ignored and controlled
        $m.remove()
    for l in $("link")
      $l = $(l)
      controlled = $l.attr 'rel'
      $l.remove() if _.indexOf(SEO.settings.ignore.link, $l.attr('rel')) is -1 and controlled
    @set(@settings, false)
    @setTitle(@settings.title)

  setTitle: (title) ->
    document.title = title
    if _.indexOf(@settings.auto.set, 'title') isnt -1
      if @settings.auto.twitter
        @setMeta 'property="twitter:title"', title
      if @settings.auto.og
        @setMeta 'property="og:title"', title

  setUrl: (url) ->
    if _.indexOf(@settings.auto.set, 'url') isnt -1
      if @settings.auto.twitter
        @setMeta 'property="twitter:url"', url
      if @settings.auto.og
        @setMeta 'property="og:url"', url

  setLink: (rel, href, unique=true) ->
    @removeLink(rel) if unique
    if _.isArray(href)
      for h in href
        @setLink(rel, h, false)
      return

    if href
      $('head').append("<link rel='#{rel}' href='#{href}'>")

  removeLink: (rel) ->
    $("link[rel='#{rel}']").remove()

  setMeta: (attr, content, unique=true) ->
    @removeMeta(attr) if unique
    if _.isArray(content)
      for v in content
        @setMeta(attr, v, false)
      return

    return unless content
    content = @escapeHtmlAttribute(content)

    $('head').append("<meta #{attr} content='#{content}'>")

    name = attr.replace(/"|'/g, '').split('=')[1]
    if _.indexOf(@settings.auto.set, name) isnt -1
      if @settings.auto.twitter
        @setMeta "property='twitter:#{name}'", content
      if @settings.auto.og
        @setMeta "property='og:#{name}'", content

  removeMeta: (attr) ->
    $("meta[#{attr}]").remove()

  escapeHtmlAttribute: (string) ->
    return ("" + string).replace(/'/g, "&apos;").replace(/"/g, "&quot;")

  getCurrentRouteName: ->
    router = Router.current()
    return unless router
    routeName = router.route.name
    return routeName
