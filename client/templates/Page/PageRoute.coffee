Template.PageRoute.helpers
  page: ->
    Pages.findOne({url: Spire.getParam("url")})

Template.PageRoute.onCreated ->
  @autorun => # @autorun is necessary, because template data may change without re-render => without calling onCreated next time
    currentData = Template.currentData()
    @subscribe "Page", currentData.url, ->
      page = Pages.findOne({url: currentData.url})
      FlowRouter.go(page.options.redirectUrl) if page.cls is "Redirect"
