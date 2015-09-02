Meteor.publish "Page", (url) ->
  check(url, String)
  Pages.find({url: url})

Meteor.publish "PagesByParentUrl", (parentUrl) ->
  check(parentUrl, String)
  Pages.find({url: Pages.Helpers.childrenUrlPattern(parentUrl)})
