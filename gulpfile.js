'use strict';

var gulp            = require('gulp'),
    sass            = require('gulp-sass'),
    autoprefixer    = require('gulp-autoprefixer'),
    glob            = require('glob'),

    CSS_SOURCE = 'lib/css/src',
    CSS_BUILD  = 'lib/css/mod_ginger_default',
    TEMPLATES  = 'templates';

gulp.task('default', ['styles', 'watch', 'livereload']);

gulp.task('watch', function () {
    gulp.watch(CSS_SOURCE + '/**/*.scss', ['styles']);
});

gulp.task('styles', function () {
    gulp.src(CSS_SOURCE + '/screen.scss')
        .pipe(sass({errLogToConsole: true}))
        .pipe(autoprefixer('last 1 version', 'ie > 7'))
        .pipe(gulp.dest(CSS_BUILD));
});