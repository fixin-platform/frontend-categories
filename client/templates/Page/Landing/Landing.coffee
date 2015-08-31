Template.Landing.helpers
#  helper: ->

Template.Landing.onCreated ->

Template.Landing.events
  "click .cta": grab encapsulate (event, template) ->
    return if Spire.requireLogin()
    recipe = @generateRecipe(
      userId: Meteor.userId()
    )
    FlowRouter.go(recipe.url())
