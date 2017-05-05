const LAUNCH_URL = process.env.LAUNCH_URL;
const FEATURES_PATH = process.env.FEATURES_PATH || '/site/features';

require('nightwatch-cucumber')({
    cucumberArgs: [
        '--require',
        'features/step_definitions',
        FEATURES_PATH,
    ]
});

module.exports = (function (settings) {
    settings.test_settings.default.launch_url = LAUNCH_URL;
    return settings;
})(require('./nightwatch.json'));
