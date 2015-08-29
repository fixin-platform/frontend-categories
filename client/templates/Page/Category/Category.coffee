Template.Category.helpers
  filter: -> Template.instance().filter.get()
  items: ->
    selector = {}
    filter = Template.instance().filter.get()
    selector.name = new RegExp(RegExp.escape(filter), "i") if filter
    @children(selector, {sort: {position: 1}})

Template.Category.onCreated ->
  @subscribe "PagesByParentUrl", @data.url
  @filter = new ReactiveVar(null)

Template.Category.onRendered ->
  @$(".filter").focus()

Template.Category.events
  "keyup .filter": (event, template) ->
    Template.instance().filter.set($(event.currentTarget).val().trim())
  "submit form": grab encapsulate (event, template) ->
    $link = template.$("a").first()
    FlowRouter.go($link.attr("href")) if $link.length
