const {client} = require('nightwatch-cucumber');
const {defineSupportCode} = require('cucumber');

defineSupportCode(({Then}) => {
    Then(/^the title is "([^"]*)"$/, (title) => {
        return client.assert.title(title);
    });

    Then(/^"([^"]*)" contains "([^"]*)"/, (element, text) => {
        return client.assert.containsText(element, text);
    });

    Then(/^I should see "([^"]*)"/, (element) => {
        return client.expect.element(element).to.be.visible;
    });
});
