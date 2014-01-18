SEO =
  settings: {
    title: ''
    description: ''
    noIndex: false
    og: {
      title: ''
      url: ''
      image: ''
    }
    staticSites: {}
  }
  config: (settings) ->
    _.extend(@settings, settings)
  set: (options) ->
    @setTitle(options.title) if options.title
    @setDescription(options.description) if options.description
    @setOpenGraph(options.og) if options.og
    @setNoIndex(options.noIndex) if options.noIndex    
  setStaticForRoute: (route) ->
    @set(@settings.staticSites[route]) if @settings.staticSites[route]
  clearAll: ->
    @setTitle(@settings.title)
    @setDescription(@settings.description)
    @setOpenGraph(@settings.og)
    @setNoIndex(@settings.noIndex)
  setOpenGraph: (og) ->
    @setOgImage(og.image) if og.image
    @setOgTitle(og.title) if og.title
    if og.url
      @setOgUrl(og.url)
    else
      @setOgUrl(location.href)
  setOgTitle: (title) ->
    @_setMeta('property="og:title"', title)
  setOgImage: (src) ->
    @_setMeta('property="og:image"', src)
  setOgUrl: (url) ->
    @_setMeta('property="og:url"', url)
  setNoIndex: (noIndex) ->
    if noIndex
      @_setMeta('name="robots"', 'noindex')
    else
      @_setMeta('name="robots"', 'index')
  setTitle: (title) ->
    document.title = title
  setDescription: (description) ->
    @_setMeta('name="description"', description)
  
  # internal helpers
  _setMeta: (attr, content) ->
    if $("meta[#{attr}]").length is 0
      if content
        $('head').append("<meta #{attr} content='#{content}'>")
    else
      if content
        $("meta[#{attr}]").attr('content', content)
      else
        $("meta[#{attr}]").remove()

@SEO = SEO



###
  $('link[rel="canonical"]').remove()
  $('link[rel="alternate"]').remove()
  if metas.setCanonical
    subDomain = Etc.getSubdomain()
    if subDomain != 'www'
      $('head').append('<link rel="canonical" href="' + Etc.getChangedSubdomainOfCurrentPath('www') + '">')
    else
      $('head').append('<link rel="alternate" hreflang="de" href="' + Etc.getChangedSubdomainOfCurrentPath('de') + '">')
###