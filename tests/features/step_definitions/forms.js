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
        const element = 'form[name="' + form + '"] button[type="submit"]';

        return client
            .useCss()
            .waitForElementVisible(element)
            .click(element);
    });

    When(/^I check "([^"]*)"$/, (label) => {
        const element = '//label[contains(., "' + label + '")]';

        return client
            .useXpath()
            .waitForElementVisible(element)
            .click(element);
    });
});
