var description = {
  summary: "Pages",
  version: "1.0.0",
  name: "pages"
};
Package.describe(description);

var path = Npm.require("path");
var fs = Npm.require("fs");
eval(fs.readFileSync("./packages/autopackage.js").toString());
Package.onUse(function(api) {
  addFiles(api, description.name, getDefaultProfiles());
  api.use(["foundation"]);
  api.use(["core"]); // this will become a proper dependency once we separate the models like Recipes and Steps into their own repositories
  api.export([
    "Pages"
  ]);
});
