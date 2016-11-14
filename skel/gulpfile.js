'use strict';

var gulp = require('gulp'),
    sass = require('gulp-sass'),
    postcss = require('gulp-postcss'),
    autoprefixer = require('autoprefixer'),
    lost = require('lost'),
    globbing = require('gulp-css-globbing');

var paths = {
    modulesSrc: [
        '../../modules/mod_ginger_foundation/lib/css/src',
    ],
    cssSource: 'lib/css/src/',
    cssDestination: 'lib/css/site/'
};

gulp.task('sass', function () {
    gulp.src(paths.cssSource + 'screen.scss')
    .pipe(globbing({ extensions: ['.scss'] }))
    .pipe(sass({
            outputStyle : 'compressed',
            errLogToConsole: true
        }))
    .on('error', handleError)
    .pipe(postcss([
        lost(),
        autoprefixer('last 2 versions', 'ie > 7')
    ]))
    .pipe(gulp.dest(paths.cssDestination));
});

gulp.task('sass:watch', function () {
    var watchPaths = [
        paths.cssSource + '/**/*.scss'
    ];

    gulp.watch(watchPaths, ['sass']);
});

function handleError(e) {
    console.log('Error: ', e);
}

gulp.task('default', ['sass', 'sass:watch']);
