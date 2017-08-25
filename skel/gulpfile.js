const gulp = require('gulp');

// Scss
const sass = require('gulp-sass');
const postcss = require('gulp-postcss');
const autoprefixer = require('autoprefixer');
const lost = require('lost');
const globbing = require('gulp-css-globbing');

// Javascript
const babel = require('gulp-babel');
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
    scssDest: 'lib/css/site',
    javascriptSrc: 'lib/js/src',
    javascriptDest: 'lib/js/dist',
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
            lost(),
            autoprefixer('last 2 versions', 'ie > 7')
        ]))
        .pipe(gulp.dest(paths.scssDest))
        .pipe(livereload());
});

// Transpiles ES6 -> minifies -> renames javaScript
gulp.task('js', () => {
    gulp.src(`${paths.javascriptSrc}/**/*.js`)
        .pipe(plumber())
        .pipe(babel({
            'presets': [
                ['env', {
                    'targets': {
                        'chrome': 52,
                        'browsers': ['last 2 versions', 'safari 7']
                    }
                }]
            ]
        }))
        .pipe(uglify())
        .pipe(rename(path => path.basename += '.min'))
        .pipe(gulp.dest(paths.javascriptDest))
        .pipe(livereload())
});

// Init livereload server and watch scss, javascript and template files for changes
gulp.task('watch', () => {
    livereload.listen();

    var scssCombinedPaths = paths.modulesSrc
        .map(x => `${x}/**/*.scss`)
        .concat(`${paths.scssSrc}/**/*.scss`);

    gulp.watch(scssCombinedPaths, { interval: 100 }, ['sass']);
    gulp.watch(`${paths.templateSrc}/**/*.tpl`, { interval: 100 }, ['tpl']);
    gulp.watch(`${paths.javascriptSrc}/**/*.js`, { interval: 100 }, ['js']);
});

gulp.task('default', ['sass', 'js', 'watch']);
