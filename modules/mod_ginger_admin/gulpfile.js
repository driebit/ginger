// 'use strict';
//
// var gulp = require('gulp'),
//     sass = require('gulp-sass'),
//     postcss = require('gulp-postcss'),
//     autoprefixer = require('autoprefixer'),
//     lost = require('lost'),
//     globbing = require('gulp-css-globbing');
//
// var paths = {
//     cssSource: 'lib/css/src/',
//     cssDestination: 'lib/css/mod_ginger_admin/'
// };
//
// gulp.task('sass', function () {
//     gulp.src(paths.cssSource + 'screen.scss')
//     .pipe(globbing({ extensions: ['.scss'] }))
//     .pipe(sass({
//             outputStyle : 'compressed',
//             errLogToConsole: true
//         }))
//     .on('error', handleError)
//     .pipe(postcss([
//         lost(),
//         autoprefixer('last 2 versions', 'ie > 7')
//     ]))
//     .pipe(gulp.dest(paths.cssDestination));
// });
//
// gulp.task('sass:watch', function () {
//
//
//     var watchPaths = [
//         paths.cssSource + '/**/*.scss'
//     ]
//
//     gulp.watch(watchPaths, ['sass']);
// });
//
// function handleError(e) {
//     console.log('error...', e);
// }
//
// gulp.task('default', ['sass', 'sass:watch']);


const gulp = require('gulp');

// Scss
const sass = require('gulp-sass');
const postcss = require('gulp-postcss');
const autoprefixer = require('autoprefixer');
const globbing = require('gulp-css-globbing');

// Javascript
const uglify = require('gulp-uglify');
const rename = require('gulp-rename');

// Prevents the pipe/stream from breaking on error
const plumber = require('gulp-plumber');

// Livereload
const livereload = require('gulp-livereload');

// Locations of scss, javascript and template files
// Add scss file paths to de the modulesSrc array to trigger scss proccessing on file change
// e.g. '../../modules/mod_ginger_foundation/lib/css/src'
const paths = {
    modulesSrc: [],
    scssSrc: 'lib/css/src',
    scssDest: 'lib/css/mod_ginger_admin',
    templateSrc: 'templates'
};

// Reload page when .tpl file changes
gulp.task('tpl', () => gulp.src('/').pipe(livereload()));

// Process, minify and prefix scss files
gulp.task('sass', () => {
    gulp.src(`${paths.scssSrc}/screen.scss`)
        .pipe(plumber())
        .pipe(globbing({ extensions: ['.scss'] }))
        .pipe(sass({ outputStyle: 'compressed' }))
        .on('error', sass.logError)
        .pipe(postcss([
            autoprefixer('last 2 versions', 'ie > 7')
        ]))
        .pipe(gulp.dest(paths.scssDest))
        .pipe(livereload());
});

// Init livereload server and watch scss, javascript and template files for changes
gulp.task('watch', () => {
    livereload.listen();

    const scssCombinedPaths = paths.modulesSrc
        .map(x => `${x}/**/*.scss`)
        .concat(`${paths.scssSrc}/**/*.scss`);

    gulp.watch(scssCombinedPaths, ['sass']);
    gulp.watch(`${paths.templateSrc}/**/*.tpl`, ['tpl']);
});

gulp.task('default', ['sass', 'watch']);
