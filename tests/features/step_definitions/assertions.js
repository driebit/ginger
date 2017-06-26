const {client} = require('nightwatch-cucumber');
const {defineSupportCode} = require('cucumber');

defineSupportCode(({Then}) => {
    Then(/^the title is "([^"]*)"$/, (title) => {
        return client.assert.title(title);
    });

    Then(/^"([^"]*)" contains "([^"]*)"$/, (element, text) => {
        return client.assert.containsText(element, text);
    });

    Then(/^the term "([^"]*)" should be defined as "([^"]*)"$/, (dtText, ddText) => {
        const selector = '//dt[contains(., "' + dtText + '")]/following-sibling::dd';

        return client
            .useXpath()
            .assert.containsText(selector, ddText);
    });

    Then(/^I should not see "([^"]*)"$/, (element) => {
        // Either the element doesn't exist in the DOM, or it does and we wait
        // for it to become invisible.
        client.elements('css selector', element, (result) => {
            if (result.value.length > 0) {
                client.useCss().waitForElementNotVisible(element);
            }
        });
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
