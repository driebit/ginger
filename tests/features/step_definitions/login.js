const {client} = require('nightwatch-cucumber');
const {defineSupportCode} = require('cucumber');

defineSupportCode(({Given}) => {
    Given(/^I log in with username "([^"]*)" and password "([^"]*)"$/, (username, password) => {
        return login(username, password, '.login--global-nav');
    });

    Given(/^I log in with username "([^"]*)" and password "([^"]*)" via "([^"]*)"$/, (username, password, link) => {
        return login(username, password, link);
    });
});

function login(username, password, link) {
    return client
        .url(client.launchUrl)
        .waitForElementVisible(link)
        .click(link)
        .waitForElementVisible('#username')
        .setValue('#username', username)
        .setValue('#password', password)
        .click('#logon_form button[type="submit"]')
        .waitForElementNotPresent(link);
}
