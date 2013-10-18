module.exports = (grunt) ->

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-htmlmin'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-haml'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-replace'
    grunt.loadNpmTasks 'grunt-autoprefixer'
    grunt.loadNpmTasks 'grunt-ftp-push'
    grunt.loadNpmTasks 'grunt-css'


    grunt.initConfig(


        pkg: grunt.file.readJSON 'package.json'


        coffee:
            options:
                bare: true
            dist:
                files:
                    'dist/index.js': '_sources/index.coffee'


        haml:
            options:
                style: 'expanded'
            dist:
                files:
                    'dist/index.html': '_sources/index.haml'


        htmlmin:
            options:
                collapseWhitespace: true
            dist:
                files:
                    'dist/index.html': 'dist/index.html'


        sass:
            options:
                style: 'expanded'
                noCache: true
            dist:
                files:
                    'dist/styles.css': '_sources/styles.scss'


        autoprefixer:
            options:
              browsers: ['last 2 version', '> 1%']
            dev:
                src: 'dist/styles.css'
                dest: 'dist/styles.css'


        cssmin:
            dist:
                src: 'dist/styles.css'
                dest: 'dist/styles.css'


        concat:
            options:
                separator: ';'
            dev:
                src: ['_sources/fullscreen.js','dist/index.js']
                dest: 'dist/index.js'


        uglify:
            dist:
                files:
                    'dist/index.min.js': 'dist/index.js'


        replace:
            dev:
                options:
                    patterns: [
                        {
                            match: 'styles'
                            replacement:  () ->
                                grunt.file.read 'dist/styles.css'
                        }
                        {
                            match: 'script'
                            replacement: () ->
                                grunt.file.read 'dist/index.js'
                        }
                    ]
                files:[
                    'dist/index.html':'dist/index.html'
                ]
            dist:
                options:
                    patterns: [
                        {
                            match: 'styles'
                            replacement:  () ->
                                grunt.file.read 'dist/styles.css'
                        }
                        {
                            match: 'script'
                            replacement: () ->
                                grunt.file.read 'dist/index.min.js'
                        }
                    ]
                files:[
                    'dist/index.html':'dist/index.html'
                ]


        clean:
            dist:
                src: ['dist/styles.css', 'dist/index.js', 'dist/index.min.js']


        watch:
            options:
                spawn: false
            coffee:
                files: ['_sources/index.coffee']
                tasks: [ 'dev' ]
            haml:
                files: ['_sources/index.haml']
                tasks: [ 'dev' ]
            sass:
                files: ['_sources/styles.scss']
                tasks: [ 'dev' ]


        ftp_push:
            options:
                authKey: 'fatbird'
                host: 'web1.fatbird.nl'
                dest: ''
                port: 21
            dist:
                files: [
                    src: ['dist/index.html']
                ]
    )

    # Default task(s).
    grunt.registerTask 'default', ['coffee','concat', 'uglify', 'haml', 'htmlmin', 'sass', 'autoprefixer', 'cssmin', 'replace:dist', 'clean', 'ftp_push' ]
    grunt.registerTask 'dev', ['coffee', 'concat', 'haml', 'sass', 'autoprefixer', 'replace:dev', 'clean']

    undefined
