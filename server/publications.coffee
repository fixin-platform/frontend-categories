Meteor.publish "Page", (url) ->
  check(url, String)
  Pages.find({url: url})

Meteor.publish "PagesByParentUrl", (parentUrl) ->
  check(parentUrl, String)
  Pages.find({url: Pages.Helpers.childrenUrlPattern(parentUrl)})

Meteor.publish "LandingPagesByRecipeCls", (cls) ->
  check(cls, String)
  Pages.find({cls: "Landing", "options.recipe.cls": cls})
