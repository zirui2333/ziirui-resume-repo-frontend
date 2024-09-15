const { defineConfig } = require('cypress')

module.exports = defineConfig({

  e2e: {
    baseUrl: 'https://c64v3yvtwepfmc5dd3mskmakn40tpsvk.lambda-url.us-east-1.on.aws/',
    specPattern: "python_test.cy.js",
    supportFile: false
  },
});