module.exports = (grunt) ->
  excludeNodeModules = ['!node_modules/**']
  jsFiles = ['**/*.js'].concat(excludeNodeModules)
  coffeeFiles = ['**/*.coffee'].concat(excludeNodeModules)
  allSourceFiles = jsFiles.concat(coffeeFiles)
  testFiles = 'test/**/*.coffee'

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffeelint: {
      files: coffeeFiles
    },
    jshint: {
      files: jsFiles
      options: {
        # enforcing options
        bitwise: true,
        camelcase: true,
        curly: true,
        eqeqeq: true,
        forin: true,
        immed: true,
        indent: 2,
        latedef: true,
        newcap: true,
        noarg: true,
        noempty: true,
        nonew: true,
        plusplus: true,
        quotmark: 'single',
        regexp: true,
        undef: true,
        unused: true,
        strict: true,
        trailing: true,
        maxparams: 5,
        maxdepth: 2,
        maxstatements: 12,
        maxcomplexity: 5,
        maxlen: 79,
        # relaxing options
        # (none right now)
        # environments
        node: true,
        laxcomma: true # comma-first style
      },
    },
    simplemocha: {
      options: {
        timeout: 250,
        ignoreLeaks: false,
        ui: 'bdd',
        reporter: 'spec'
      },
      all: { src: testFiles }
    },
    watch: {
      js: {
        files: jsFiles,
        tasks: ['test']
      }
      coffee: {
        files: coffeeFiles,
        tasks: [ 'test']
      }
    }
  })

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-simple-mocha'

  grunt.registerTask 'test',      ['simplemocha' ]

  grunt.registerTask 'default',   [ 'coffeelint', 'jshint', 'test']
