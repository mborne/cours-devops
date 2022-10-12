const path = require('path');
const shell = require('shelljs');

const convert = require('@mborne/markdown-to-html').convert;

console.log('rm -rf docs...');
shell.rm('-rf',path.resolve(__dirname,'docs'));

console.log('src/slides -> docs with layout/slides...');
convert({
    outputDir: path.resolve(__dirname,'docs'),
    rootDir: path.resolve(__dirname,'src/slides'),
    layoutPath: path.resolve(__dirname,'layout/slides')
});

console.log('src/annexe -> docs/annexe with default layout...');
convert({
    outputDir: path.resolve(__dirname,'docs/annexe'),
    rootDir: path.resolve(__dirname,'src/annexe'),
    layoutPath: path.resolve(__dirname,'node_modules/@mborne/markdown-to-html/layout/github')
});
