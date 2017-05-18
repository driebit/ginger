let chromedriver = require('chromedriver');

module.exports = {
    waitForConditionTimeout: 8000,

    'default': {
        local: false
    },

    'chrome': {
        local: true
    },

    before: function (done) {
        if (this.local) {
            chromedriver.start();
        }

        done();
    },

    after: function (done) {
        if (this.local) {
            chromedriver.stop();
        }

        done();
    }
};
