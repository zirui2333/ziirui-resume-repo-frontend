const { defineConfig } = require('cypress')

module.exports = defineConfig({

  e2e: {
    baseUrl: 'https://evjwodhvurdul6u545smt3yfay0syutw.lambda-url.us-east-1.on.aws/',
    specPattern: "python_test.cy.js",
    supportFile: false
  },
});