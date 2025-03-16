const path = require('path');
const shell = require('shelljs');

const {Marpit} = require('@marp-team/marpit');
const fs = require('fs');

console.log('rm -rf public...');
shell.rm('-rf',path.resolve(__dirname,'public'));

const options = {
    language: "fr"
}


/*
 * Render slides using marp-cli
 * https://github.com/marp-team/marp-cli#readme
 */
console.log('src/slides -> public ...');
shell.exec('npx marp --html=true --theme ./src/slides/marp-ensg.css -I ./src/slides/ -o ./public/');
/*
 * Copy src/slides/img to public/img
 */
console.log('src/slides/img -> public/img ...');
shell.cp('-r',path.resolve(__dirname,'src/slides/img'),path.resolve(__dirname,'public/.'))

/*
 * Render src/annexe to public/annexe
 */
const convert = require('@mborne/markdown-to-html').convert;

console.log('src/annexe -> public/annexe with default layout...');
convert(
    path.resolve(__dirname,'src/annexe'),
    path.resolve(__dirname,'public/annexe'),
    path.resolve(__dirname,'layout/annexe'),
    options
);
