Template.PageRoute.helpers
  page: ->
    Pages.findOne({url: Spire.getParam("url")})

Template.PageRoute.onCreated ->
  @autorun =>
    url = Template.currentData().url
    @subscribe "Page", url, ->
      page = Pages.findOne({url: url})
      FlowRouter.go(page.options.redirectUrl) if page.cls is "Redirect"
