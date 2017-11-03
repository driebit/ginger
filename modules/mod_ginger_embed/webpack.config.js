// const autoprefixer = require('autoprefixer');
// const ExtractTextPlugin = require('extract-text-webpack-plugin');

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
        modules: ['node_modules', path.resolve(__dirname, "src")]
    },
    module: {
        rules: [{
            test: /\.(html)$/,
            use: {
                loader: 'html-loader',
                options: {
                    attrs: [':data-src']
                }
            }
        }]
    },
    plugins: []
}
