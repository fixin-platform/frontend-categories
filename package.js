var description = {
  summary: "Categories",
  version: "1.0.0",
  name: "frontend-categories"
};
Package.describe(description);

var path = Npm.require("path");
var fs = Npm.require("fs");
eval(fs.readFileSync("./packages/autopackage.js").toString());
Package.onUse(function(api) {
  addFiles(api, description.name, getDefaultProfiles());
  api.use(["frontend-fixtures@1.0.0"]);
  api.imply(["frontend-fixtures"]);

  api.export([
    "Pages"
  ]);
});
