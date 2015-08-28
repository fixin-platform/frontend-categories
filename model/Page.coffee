Transformations["Page"] = (object) -> Transformations.dynamic(Pages, Pages.Page, object)
Pages = Collections["Page"] = new Mongo.Collection("Pages", {transform: if Meteor.isClient then Transformations.Page else null})

class Pages.Page
  constructor: (doc) ->
    _.extend(@, doc)
  siblings: (options) ->
    Pages.find({url: @siblingUrlPattern()}, options)
  lastSibling: ->
    Pages.findOne({url: @siblingUrlPattern()}, {sort: {position: -1}})
  parentUrl: ->
    @url.substr(0, @url.lastIndexOf("/"))
  siblingUrlPattern: ->
    parentUrl = @parentUrl()
    new RegExp(RegExp.escape(parentUrl) + "\/[\/]+")
#  url: ->
#    url = ""
#    for parent in Pages.find({rootId: @rootId, level: {$gt: @level}}, {sort: {level: 1}})
#      url += "/" + parent.slug
#    url

PageMatch = ->
  _id: Match.StringId
  url: String
  position: Match.Integer
  updatedAt: Date
  createdAt: Date

PagePreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Pages.before.insert (userId, Page) ->
  LastPage = Transformations.Page(Page).lastSibling()
  now = new Date()
  _.defaults Page,
    _id: Random.id()
    position: if LastPage then LastPage.position + 1 else 1
    updatedAt: now
    createdAt: now
  check Page, PageMatch()
  PagePreSave.call(@, userId, Page)
  true

Pages.before.update (userId, Page, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  PagePreSave.call(@, userId, modifier.$set)
  true
