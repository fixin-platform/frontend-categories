class Pages.Landing extends Pages.Page
  generateRecipe: (defaults, callback) ->
    recipeId = Recipes.insert _.defaults @options.recipe, defaults
    recipe = Recipes.findOne recipeId, {transform: Transformations.Recipe}
    recipe.generateSteps()
    recipe
