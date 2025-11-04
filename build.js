const path = require('path');
const shell = require('shelljs');

console.log('rm -rf public...');
shell.rm('-rf',path.resolve(__dirname,'public'));

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
console.log('src/slides/schema -> public/schema ...');
shell.cp('-r',path.resolve(__dirname,'src/slides/schema'),path.resolve(__dirname,'public/.'))
