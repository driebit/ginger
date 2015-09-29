'use strict';

var gulp = require('gulp'),
    sass = require('gulp-sass'),
    postcss = require('gulp-postcss'),
    sourcemaps = require('gulp-sourcemaps'),
    autoprefixer = require('autoprefixer'),
    lost = require('lost'),
    livereload = require('gulp-livereload');

var paths = {
    cssSource: 'lib/css/src/',
    cssDestination: 'lib/css/mod_ginger_admin/',
    templates: 'templates/',

};

gulp.task('watch', function() {
    var watchPaths = [
        paths.cssSource + '/**/*.scss'
    ].concat();

    gulp.watch(watchPaths, ['styles']);

});

gulp.task('styles', function() {
    return gulp.src(paths.cssSource + '**/*.scss')
        .pipe(sass({
            errLogToConsole: true
        }))
        .pipe(postcss([
            lost(),
            autoprefixer('last 1 version', 'ie > 7')
        ]))
        .pipe(gulp.dest(paths.cssDestination));
});

gulp.task('livereload', function() {
    var server = livereload();

    gulp.watch(paths.cssSource + '/**/*.css').on('change', function(file) {
        server.changed(file.path);
    });

    gulp.watch(paths.templates + '/**/*.tpl').on('change', function(file) {
        server.changed(file.path);
    });
});

gulp.task('default', ['styles', 'livereload', 'watch']);
