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
                    '.temp/index.js': 'src/index.coffee'


        haml:
            options:
                style: 'expanded'
            dist:
                files:
                    '.temp/index.html': 'src/index.haml'


        htmlmin:
            options:
                collapseWhitespace: true
            dist:
                files:
                    'dist/index.html': '.temp/index.html'


        sass:
            options:
                style: 'expanded'
                noCache: true
            dist:
                files:
                    '.temp/styles.css': 'src/styles.scss'


        autoprefixer:
            options:
                browsers: ["ff 23", "chrome 28", "ios 5", "ie 10"]
            dist:
                src: '.temp/styles.css'
                dest: '.temp/styles.css'


        cssmin:
            dist:
                src: '.temp/styles.css'
                dest: '.temp/styles.css'


        concat:
            options:
                separator: ';'
            dist:
                src: ['.temp/index.js']
                dest: '.temp/index.concatenated.js'


        uglify:
            options:
                mangle: false
                compress: false
                report: true
                wrap: "true"
            dist:
                files:
                    '.temp/index.min.js': '.temp/index.js'


        replace:
            dev:
                options:
                    patterns: [
                        {
                            match: 'styles'
                            replacement:  () ->
                                grunt.file.read '.temp/styles.css'
                        }
                        {
                            match: 'script'
                            replacement: () ->
                                grunt.file.read '.temp/index.js'
                        }
                    ]
                files:[
                    'dist/index.html':'.temp/index.html'
                ]
            dist:
                options:
                    patterns: [
                        {
                            match: 'styles'
                            replacement:  () ->
                                grunt.file.read '.temp/styles.css'
                        }
                        {
                            match: 'script'
                            replacement: () ->
                                grunt.file.read '.temp/index.min.js'
                        }
                    ]
                files:[
                    'dist/index.html':'.temp/index.html'
                ]


        clean:
            dist:
                src: ['.temp']


        watch:
            options:
                spawn: false
            coffee:
                files: ['src/index.coffee']
                tasks: [ 'dev' ]
            haml:
                files: ['src/index.haml']
                tasks: [ 'dev' ]
            sass:
                files: ['src/styles.scss']
                tasks: [ 'dev' ]


        ftp_push:
            options:
                authKey: 'pm5544'
                host: 'pm5544.eu'
                dest: ''
                port: 21
            dist:
                files: [
                    src: ['dist/index.html','dist/128.png', '196.png']
                ]
    )

    # Default task(s).
    grunt.registerTask 'default', ['coffee', 'uglify', 'haml', 'htmlmin', 'sass', 'autoprefixer', 'cssmin', 'replace:dist', 'clean', 'ftp_push']
    grunt.registerTask 'dev', ['coffee', 'haml', 'sass', 'autoprefixer', 'replace:dev', 'clean', 'watch' ]

    undefined
