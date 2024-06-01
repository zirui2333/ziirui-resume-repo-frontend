const { defineConfig } = require('cypress')

module.exports = defineConfig({

  e2e: {
    baseUrl: 'https://7m6lwapwwvhhjwvhnxwntpi2ba0nctzb.lambda-url.us-east-1.on.aws/',
    specPattern: "python_test.cy.js",
    supportFile: false
  },
});