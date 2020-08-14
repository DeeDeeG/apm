#!/usr/bin/env node

var cp = require('child_process')
var fs = require('fs')
var path = require('path')

if (process.platform === 'win32') {
  npmWrapperExtension = '.cmd'
} else {
  npmWrapperExtension += ''
}

const npmWrapperPath = path.join(__dirname, '..', 'bin', 'npm' + npmWrapperExtension)

// Make sure all the scripts have the necessary permissions when we execute them
// (npm does not preserve permissions when publishing packages on Windows,
// so this is especially needed to allow apm to be published successfully on Windows)
fs.chmodSync(path.join(__dirname, '..', 'bin', 'apm'), 0o755)
fs.chmodSync(path.join(__dirname, '..', 'bin', 'npm'), 0o755)

// var child = cp.spawn(script, [], { stdio: ['pipe', 'pipe', 'pipe'], shell: true })
// child.stderr.pipe(process.stderr)
// child.stdout.pipe(process.stdout)

console.log('>> Downloading bundled Node')
cp.spawnSync(
  'node',
  [path.join(__dirname, 'download-node.js')]
)

const downloadedNodeVersionAndArch = cp.execFileSync('./bin/node', ['-p', 'process.version + " " + process.arch'], { encoding: 'utf8' })

console.log('\n>> Rebuilding apm dependencies with bundled Node ' + downloadedNodeVersionAndArch)
cp.execFileSync(
  npmWrapperPath,
  ['rebuild']
)

if (process.env.NO_APM_DEDUPE && process.env.NO_APM_DEDUPE.length > 0) {
  console.log('\n>> Deduplication disabled')
} else {
  console.log('\n>> Deduping apm dependencies')
  cp.execFileSync(
    npmWrapperPath,
    ['dedupe']
  )
}
