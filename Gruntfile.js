module.exports = function(grunt) {
  grunt.initConfig({

    browserify: {
      dist: {
        files: {
          'dist/js/bundle.js': ['src/app.coffee']
        },
        options: {
          transform: ['coffeeify']
        }
      }
    },

    copy: {
      main: {
        files: [{
          expand: true,
          flatten: true,
          src: ['src/index.html'],
          dest: 'dist/'
        }, {
          expand: true,
          flatten: true,
          src: [
            'bower_components/three.js/three.min.js'
          ],
          dest: 'dist/js/vendor'
        }]
      }
    },

    connect: {
      server: {
        options: {
          port: 3000,
          base: 'dist',
          livereload: true,
          open: true
        }
      }
    },

    watch: {
      main: {
        files: ['src/**/*.{js,coffee}', 'Gruntfile.js'],
        tasks: ['mochaTest', 'browserify', 'copy'],
        options: {
          livereload: true
        }
      }
    },

    clean: ['dist'],

    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          require: 'coffee-script/register'
        },
        src: [
          'src/core/test/**/*.{js,coffee}',
          'src/test/**/*.{js,coffee}'
        ]
      },
    }

  });

  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-mocha-test');

  grunt.registerTask('default', ['mochaTest', 'clean', 'browserify', 'copy', 'connect', 'watch']);
};