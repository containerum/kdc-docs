'use strict';

var gulp = require('gulp'),
    prefixer = require('gulp-autoprefixer'),
    uglify = require('gulp-uglify'),
    sass = require('gulp-sass'),
    sourcemaps = require('gulp-sourcemaps'),
    cssmin = require('gulp-minify-css'),
    imagemin = require('gulp-imagemin'),
    rigger = require('gulp-rigger'),
    watch = require('gulp-watch'),
    rimraf = require('rimraf');

var path = {
    build: {
        js: 'static/js/',
        css: 'static/css/',
        img: 'static/img/',
        fonts: 'static/fonts/'
    },
    src: {
        js: 'static_src/js/main.js',
        style: 'static_src/css/main.scss',
        img: 'static_src/img/**/*.*',
        fonts: 'static_src/fonts/**/*.*'
    },
    watch: {
        js: 'static_src/js/**/*.js',
        style: 'static_src/css/**/*.*',
        img: 'static_src/img/**/*.*',
        fonts: 'static_src/fonts/**/*.*'
    },
    clean: './static'
};

gulp.task('js:build', function () {
    gulp.src(path.src.js)
        .pipe(rigger())
        .pipe(sourcemaps.init()) //Init sourcemap
        .pipe(uglify()) //Compress
        .pipe(sourcemaps.write()) //Write sourcemap
        .pipe(gulp.dest(path.build.js));
});

gulp.task('style:build', function () {
    gulp.src(path.src.style)
        .pipe(sourcemaps.init()) //Init sourcemap
        .pipe(sass()) //Compile
        .pipe(prefixer()) //Add vendor prefixers
        .pipe(cssmin()) //Compress
        .pipe(sourcemaps.write()) //Write sourcemap
        .pipe(gulp.dest(path.build.css));
});

gulp.task('image:build', function () {
    gulp.src(path.src.img)
        .pipe(gulp.dest(path.build.img));
});

gulp.task('fonts:build', function() {
    gulp.src(path.src.fonts)
        .pipe(gulp.dest(path.build.fonts))
});

gulp.task('build', [
    'js:build',
    'style:build',
    'fonts:build',
    'image:build'
]);

gulp.task('watch', function(){
    watch([path.watch.style], function(event, cb) {
        gulp.start('style:build');
    });
    watch([path.watch.js], function(event, cb) {
        gulp.start('js:build');
    });
    watch([path.watch.img], function(event, cb) {
        gulp.start('image:build');
    });
    watch([path.watch.fonts], function(event, cb) {
        gulp.start('fonts:build');
    });
});

gulp.task('clean', function (cb) {
    rimraf(path.clean, cb);
});

gulp.task('default', ['build', 'watch']);
