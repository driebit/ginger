var gulp         = require('gulp'),
    sass         = require('gulp-sass'),
    autoprefixer = require('gulp-autoprefixer'),

    CSS_SOURCE   = 'lib/css/src',
    CSS_BUILD    = 'lib/css/mod_ginger_site',
    JS_SOURCE    = 'lib/js/src',
    JS_BUILD     = 'lib/js/build';
    TEMPLATES    = 'templates'

gulp.task('default', ['styles', 'watch']);

gulp.task('watch', function () {
    gulp.watch(CSS_SOURCE + '/**/*.scss', ['styles']);
});

gulp.task('styles', function () {
    gulp.src(CSS_SOURCE + '/screen.scss')
        .pipe(sass({errLogToConsole: true}))
        .pipe(autoprefixer('last 1 version', 'ie > 7'))
        .pipe(gulp.dest(CSS_BUILD));
});
