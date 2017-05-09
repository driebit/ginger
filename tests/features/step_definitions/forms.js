const {client} = require('nightwatch-cucumber');
const {defineSupportCode} = require('cucumber');

defineSupportCode(({When}) => {
    When(/^I fill in "([^"]*)" with "([^"]*)"$/, (input, text) => {
        return client.setValue('input[name="' + input + '"]', text);
    });

    When(/^I fill in "([^"]*)" with "([^"]*)" in form "([^"]*)"$/, (input, text, form) => {
        return client.setValue('form[name="' + form + '"] input[name="' + input + '"]', text);
    });

    When(/^I submit "([^"]*)"$/, (form) => {
        return client.click('form[name="' + form + '"] button[type="submit"]');
    });

    When(/^I check "([^"]*)"$/, (label) => {
        return client
            .useXpath()
            .click('//label[contains(., "' + label + '")]');
    });
});
