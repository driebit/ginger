const {client} = require('nightwatch-cucumber');
const {defineSupportCode} = require('cucumber');

defineSupportCode(({Then}) => {
    Then(/^the title is "([^"]*)"$/, (title) => {
        return client.assert.title(title);
    });

    Then(/^"([^"]*)" contains "([^"]*)"$/, (element, text) => {
        return client.assert.containsText(element, text);
    });

    Then(/^I should not see "([^"]*)"$/, (element) => {
        return client.useCss().waitForElementNotVisible(element);
    });

    Then(/^I should see "([^"]*)"$/, (element) => {
        return client.useCss().waitForElementVisible(element);
    });

    Then(/^there should be (\d+) "([^"]*)" elements$/, (number, element) => {
        // Replace this hard wait with a custom waitForElementCount command.
        client.pause(500);

        return client.elements('css selector', element, (result) => {
            client.assert.equal(result.value.length, number);
        });
    })
});
