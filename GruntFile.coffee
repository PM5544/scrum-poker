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
                    'tmp/index.js': '_src/index.coffee'


        haml:
            options:
                style: 'expanded'
            dist:
                files:
                    'tmp/index.html': '_src/index.haml'


        htmlmin:
            options:
                collapseWhitespace: true
            dist:
                files:
                    'dist/index.html': 'tmp/index.html'


        sass:
            options:
                style: 'expanded'
                noCache: true
            dist:
                files:
                    'tmp/styles.css': '_src/styles.scss'


        autoprefixer:
            options:
                browsers: ["ff 23", "chrome 28", "ios 5"]
            dist:
                src: 'tmp/styles.css'
                dest: 'tmp/styles.css'


        cssmin:
            dist:
                src: 'tmp/styles.css'
                dest: 'tmp/styles.css'


        concat:
            options:
                separator: ';'
            dist:
                src: ['_src/fullscreen.js','tmp/index.js']
                dest: 'tmp/index.concatenated.js'


        uglify:
            options:
                mangle: false
                compress: false
                report: true
                wrap: "true"
            dist:
                files:
                    'tmp/index.concatenated.min.js': 'tmp/index.concatenated.js'


        replace:
            dev:
                options:
                    patterns: [
                        {
                            match: 'styles'
                            replacement:  () ->
                                grunt.file.read 'tmp/styles.css'
                        }
                        {
                            match: 'script'
                            replacement: () ->
                                grunt.file.read 'tmp/index.concatenated.js'
                        }
                    ]
                files:[
                    'dist/index.html':'tmp/index.html'
                ]
            dist:
                options:
                    patterns: [
                        {
                            match: 'styles'
                            replacement:  () ->
                                grunt.file.read 'tmp/styles.css'
                        }
                        {
                            match: 'script'
                            replacement: () ->
                                grunt.file.read 'tmp/index.concatenated.min.js'
                        }
                    ]
                files:[
                    'dist/index.html':'tmp/index.html'
                ]


        clean:
            dist:
                src: ['tmp']


        watch:
            options:
                spawn: false
            coffee:
                files: ['_src/index.coffee']
                tasks: [ 'dev' ]
            haml:
                files: ['_src/index.haml']
                tasks: [ 'dev' ]
            sass:
                files: ['_src/styles.scss']
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
    grunt.registerTask 'default', ['coffee','concat', 'uglify', 'haml', 'htmlmin', 'sass', 'autoprefixer', 'cssmin', 'replace:dist', 'clean', 'ftp_push']
    grunt.registerTask 'dev', ['coffee', 'concat', 'haml', 'sass', 'autoprefixer', 'replace:dev', 'clean']

    undefined
