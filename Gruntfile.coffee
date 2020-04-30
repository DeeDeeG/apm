module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      glob_to_multiple:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'lib'
        ext: '.js'

    coffeelint:
      options:
        configFile: 'coffeelint.json'
      src: ['src/**/*.coffee']
      test: ['spec/*.coffee']
      gruntfile: ['Gruntfile.coffee']

    shell:
      test:
        command: 'node node_modules/jasmine-node/bin/jasmine-node --captureExceptions --coffee --color spec'
        options:
          stdout: true
          stderr: true
          failOnError: true

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-coffeelint')

  grunt.registerTask 'clean', ->
    grunt.file.delete('lib') if grunt.file.exists('lib')
    grunt.file.delete('bin/node_darwin_x64') if grunt.file.exists('bin/node_darwin_x64')
    grunt.file.delete('node_modules/with a space') if grunt.file.exists('node_modules/with a space')
    grunt.file.delete('native-module/build') if grunt.file.exists('native-module/build')

  grunt.registerTask('lint', ['coffeelint'])
  grunt.registerTask('default', ['coffee', 'lint'])
  grunt.registerTask('test', ['clean', 'default', 'shell:test'])
  grunt.registerTask('prepare', ['clean', 'coffee', 'lint'])
