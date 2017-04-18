const {client} = require('nightwatch-cucumber');
const {defineSupportCode} = require('cucumber');

defineSupportCode(({When}) => {
    When(/^I fill in "([^"]*)" with "([^"]*)"/, (input, text) => {
        return client
            .setValue('input[name="' + input + '"]', text);
    });
});
