module.exports = function(grunt) {
  grunt.initConfig({

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
            'bower_components/jquery/dist/jquery.min.map',
            'bower_components/cpr/cpr.js',
            'bower_components/tinycolor/dist/tinycolor-min.js',
            'bower_components/dat-gui/build/dat.gui.min.js',
            'bower_components/threex.rendererstats/threex.rendererstats.js',
            'node_modules/shader-particle-engine/build/SPE.min.js',
            'node_modules/cannon/build/cannon.js',
            'node_modules/cannon/build/cannon.min.js'
          ],
          dest: 'dist/js/vendor'
        }, {
          expand: true,
          flatten: true,
          src: ['build/js/*.js'],
          dest: 'dist/js/'
        }, {
          expand: true,
          flatten: true,
          src: ['src/images/*'],
          dest: 'dist/images'
        }, {
          expand: true,
          flatten: true,
          src: ['bower_components/cpr/cpr.css'],
          dest: 'dist/css'
        }, {
          expand: true,
          cwd: 'src/threejs',
          src: ['**/*.js'],
          dest: 'dist/js/threejs'
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
        files: ['src/index.html', 'build/js/bundle.js', 'src/images/*', 'src/gui/*.css', 'Gruntfile.js'],
        tasks: ['copy', 'mochaTest'],
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

  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-mocha-test');

  grunt.registerTask('default', ['clean', 'mochaTest', 'copy', 'connect', 'watch']);
  grunt.registerTask('test', ['mochaTest', 'watch']);

};