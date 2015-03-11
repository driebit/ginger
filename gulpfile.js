'use strict';

var gulp            = require('gulp'),
    sass            = require('gulp-sass'),
    autoprefixer    = require('gulp-autoprefixer'),
    livereload      = require('gulp-livereload'),
    cssInlineImages = require('gulp-css-inline-images'),
    glob            = require('glob'),
    svgToPng        = require('svg-to-png'),
    path            = require('path'),

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

gulp.task('inline-images', function () {
    gulp.src('*.css')
        .pipe(cssInlineImages({
            webRoot: 'web',
            path: 'images'
        }))
        .pipe(gulp.dest('build'));
});

gulp.task('svg-to-png', function (done) {
    glob('lib/images/*.svg', function (er, files) {
        if (er) {
            throw new Error(er);
        }

        svgToPng.convert(files, 'lib/images', {
            compress: true,
            optimizationLevel: 7
        }).then(function () {
            done();
        });
    });
});

gulp.task('livereload', function () {
    var server = livereload();

    gulp.watch(CSS_BUILD + '/**/*.css').on('change', function (file) {
        server.changed(file.path);
    });

    gulp.watch(TEMPLATES + '/**/*.tpl').on('change', function (file) {
        server.changed(file.path);
    });
});
