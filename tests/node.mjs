// Run with: node --experimental-modules tests/node.mjs

import glslangModule from '../dist/node-devel/glslang.js';
import { testCases, runTest } from './helper.mjs';

const glslang = glslangModule();
for (const c of testCases) {
    console.log(c);
    runTest(glslang, ...c);
}
console.log('Done!');
