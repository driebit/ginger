const {client} = require('nightwatch-cucumber');
const {defineSupportCode} = require('cucumber');

defineSupportCode(({When}) => {
    When(/^I follow "([^"]*)"/, (linkText) => {
        return client
            .useXpath()
            .click('//a[contains(., "' + linkText + '")]');
    });

    When(/^I visit "([^"]*)"/, (url) => {
        return client
            .url(client.launch_url + url)
            .waitForElementVisible('body');
    });

    When(/^I press "([^"]*)"/, (key) => {
        return client.keys([client.Keys[key]]);
    });
});
