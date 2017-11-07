const path = require('path');
const webpack = require('webpack');

const entryPath = path.join(__dirname, 'lib/js/src/embed.js');
const outputPath = path.join(__dirname, 'lib/js');

module.exports = {
    entry: entryPath,
    output: {
        publicPath: '/',
        path: outputPath,
        filename: `embed.js`,
    },
    resolve: {
        extensions: ['.js'],
        modules: ["node_modules", "src"]
    },
    module: {
        rules: [{
            test: /\.js$/,
            exclude: /(node_modules|bower_components)/,
            use: {
                loader: 'babel-loader',
                options: {
                    presets: ["@babel/preset-env"],
                    plugins: ["transform-custom-element-classes"]
                }
            }
        }]
    },
    plugins: []
}
