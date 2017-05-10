const {client} = require('nightwatch-cucumber');
const {defineSupportCode} = require('cucumber');

defineSupportCode(({When}) => {
    When(/^I follow "([^"]*)"$/, (linkText) => {
        return client
            .useXpath()
            .click('//a[contains(., "' + linkText + '")]');
    });

    When(/^I visit "([^"]*)"$/, (url) => {
        return client
            .url(client.launch_url + url)
            .waitForElementVisible('body');
    });

    When(/^I click on "([^"]*)"$/, (css) => {
        return client
            .useCss()
            .waitForElementVisible(css)
            .click(css);
    });

    When(/^I click on list item "([^"]*)"$/, (text) => {
        let selector = '//li[contains(., "' + text + '")]';
        return client
            .useXpath()
            .waitForElementVisible(selector)
            .click(selector);
    });

    When(/^I press "([^"]*)"$/, (key) => {
        return client.keys([client.Keys[key]]);
    });

    When(/^I scroll to "([^"]*)"$/, (element) => {
        return client.getLocationInView(element, () => {
            // Scroll a little extra to trigger lazy actions such as infinite
            // scroll.
            return client.execute('window.scrollBy(0, 100)');
        });
    });
});
