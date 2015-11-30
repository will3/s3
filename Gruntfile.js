module.exports = function(grunt) {
  grunt.initConfig({

    watchify: {
      options: {
        extensions: ['.js', '.coffee'],
        keepalive: true,
        callback: function(b) {
          b.transform("coffeeify");
          return b;
        }
      },

      dist: {
        src: './src/app.coffee',
        dest: './src/bundle.js'
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
            'bower_components/three.js/three.min.js',
            'bower_components/lodash/lodash.min.js',
            'bower_components/jquery/dist/jquery.min.js',
            'bower_components/jquery/dist/jquery.min.map'
          ],
          dest: 'dist/js/vendor'
        }, {
          expand: true,
          flatten: true,
          src: ['src/bundle.js'],
          dest: 'dist/js/'
        }, {
          expand: true,
          flatten: true,
          src: ['src/images/*'],
          dest: 'dist/images'
        }, {
          expand: true,
          flatten: true,
          src: ['src/gui/gui.css'],
          dest: 'dist/css'
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
        files: ['src/index.html', 'src/bundle.js', 'src/images/*', 'src/gui/*.css', 'Gruntfile.js'],
        tasks: ['mochaTest', 'copy'],
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
    },

    concurrent: {
      dev: {
        tasks: ['build', 'dist'],
        options: {
          logConcurrentOutput: true
        }
      }
    }

  });

  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-watchify');
  grunt.loadNpmTasks('grunt-concurrent');

  grunt.registerTask('dist', ['clean', 'copy', 'connect', 'watch']);
  grunt.registerTask('build', 'mochaTest', 'watchify');
  grunt.registerTask('default', 'concurrent:dev');
};