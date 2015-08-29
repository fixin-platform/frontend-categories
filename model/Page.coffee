Transformations["Page"] = (object) -> Transformations.dynamic(Pages, Pages.Page, object)
Pages = Collections["Page"] = new Mongo.Collection("Pages", {transform: if Meteor.isClient then Transformations.Page else null})

class Pages.Page
  constructor: (doc) ->
    _.extend(@, doc)
    @template ?= @cls
    @i18nKey ?= @url
  children: (selector = {}, options = {}) ->
    Pages.find(_.extend({url: Pages.Helpers.childrenUrlPattern(@url)}, selector), options)
  siblings: (selector = {}, options = {}) ->
    Pages.find(_.extend({url: Pages.Helpers.siblingsUrlPattern(@url), _id: {$ne: @_id}}, selector), options)
  lastSibling: ->
    Pages.findOne({url: Pages.Helpers.siblingsUrlPattern(@url), _id: {$ne: @_id}}, {sort: {position: -1}})
  _i18n: ->
    key = @_i18nKey()
    parameters = @_i18nParameters()
    result = i18n.t(key, _.extend({returnObjectTrees: true}, parameters))
    result = {} if result is key # i18n not found
    throw new Meteor.Error("_i18n:not-an-object", "", {result: result}) if not _.isObject(result)
    _.defaults(result, @_i18nDefaults())
  _i18nKey: -> "Pages.#{@i18nKey}"
  _i18nParameters: -> {}
  _i18nDefaults: -> {}

Pages.Helpers =
  childrenUrlPattern: (parentUrl) ->
    parentUrlWithoutLastSlash = parentUrl.replace /\/$/, ""
    new RegExp("^" + RegExp.escape(parentUrlWithoutLastSlash) + "\/[^\/]+$")
  parentUrl: (childUrl) ->
    childUrl.substr(0, childUrl.lastIndexOf("/"))
  siblingsUrlPattern: (siblingUrl) ->
    Pages.Helpers.childrenUrlPattern Pages.Helpers.parentUrl(siblingUrl)

#  url: ->
#    url = ""
#    for parent in Pages.find({rootId: @rootId, level: {$gt: @level}}, {sort: {level: 1}})
#      url += "/" + parent.slug
#    url

PageMatch = (Page) ->
  _id: Match.StringId
  url: String
  cls: String
  options: Object
  position: Match.Integer
  updatedAt: Date
  createdAt: Date

PagePreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

Pages.before.insert (userId, Page) ->
  Page._id ?= Random.id()
  now = new Date()
  _.autovalues Page,
    options: {}
    position: (Page) ->
      LastPage = Transformations.Page(Page).lastSibling()
      if LastPage then LastPage.position + 1 else 1
    updatedAt: now
    createdAt: now
  check Page, PageMatch(Page)
  PagePreSave.call(@, userId, Page)
  true

Pages.before.update (userId, Page, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  PagePreSave.call(@, userId, modifier.$set)
  true
