const {client} = require('nightwatch-cucumber');
const {defineSupportCode} = require('cucumber');

defineSupportCode(({After, setDefaultTimeout}) => {
    // Set Cucumber timeout
    setDefaultTimeout(8000);

    After(function () {
        // Close the browser to start the next test with a fresh session.
        return client.end();
    });
});
