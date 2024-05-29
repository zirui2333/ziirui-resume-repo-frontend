const { defineConfig } = require('cypress')

module.exports = defineConfig({

  e2e: {
    baseUrl: 'https://evjwodhvurdul6u545smt3yfay0syutw.lambda-url.us-east-1.o.aws/',
    specPattern: "python_test.cy.js",
    supportFile: false
  },
});