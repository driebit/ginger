var gulp            = require('gulp'),
    sass            = require('gulp-sass'),
    autoprefixer    = require('gulp-autoprefixer'),
    livereload      = require('gulp-livereload'),
    cssInlineImages = require('gulp-css-inline-images'),

    CSS_SOURCE   = 'lib/css/src',
    CSS_BUILD    = 'lib/css/mod_ginger_default',
    JS_SOURCE    = 'lib/js/src',
    JS_BUILD     = 'lib/js/build',
    TEMPLATES    = 'templates';


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

gulp.task('livereload', function () {
    var server = livereload();

    gulp.watch(CSS_BUILD + '/**/*.css').on('change', function (file) {
        server.changed(file.path);
    });

    gulp.watch(TEMPLATES + '/**/*.tpl').on('change', function (file) {
        server.changed(file.path);
    });
});
