const {client} = require('nightwatch-cucumber');
const {defineSupportCode} = require('cucumber');

defineSupportCode(({After}) => {
    After(function () {
        // Close the browser to start the next test with a fresh session.
        return client.end();
    });
});
