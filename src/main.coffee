audio = require 'audio'
loading = require 'loading'
Shader = require 'webgl/shader'

load_hooks =
    '\.jpg$|\.jpeg$|\.gif$|\.png': (buffer, callback) ->
        image = new Image()
        image.src = getURL(buffer)
        image.onload = ->
            callback image
    '\.mpg$|\.ogg$|\.wav$': (buffer, callback) ->
        audio.decode buffer, (result) ->
            callback result
    '\.shader$': (source, callback) ->
        callback new Shader(gl, source)

exports.main = ->
    document.oncontextmenu = ->
        return false
    window.canvas = $ 'canvas'
    try
        window.gl = canvas[0].getContext 'experimental-webgl'
        if not window.gl
            window.gl = canvas[0].getContext 'webgl'

    if window.gl
        gl.getExtension 'OES_standard_derivatives'

        Application = require('application').Application
        application = null

        loading.show 'Loading ...'

        loader.hooks(load_hooks).mount
            url: 'assets.pack',
            loaded: ->
                application = new Application(window.canvas, window.gl)
            progress: loading.progress
    else
        canvas.remove()
        $('#ui').empty()
        container = $('<div></div>')
            .css(
                position: 'absolute',
                width: 300,
                left: '50%',
                top: 50,
                marginLeft: -100
            )
            .appendTo('#ui')

        container.append('<h1>You dont have WebGL</h1>')
        if $.browser.msie
            container.append('<p>You have Internet Explorer, please install <a href="https://www.google.com/intl/en/chrome/browser/">Google Chrome</a> or <a href="http://www.mozilla.org/en-US/firefox/new/">Firefox</a></p>')
        else if $.browser.webkit
            container.append('<p>If you use OSX Safari, please <a href="http://www.ikriz.nl/2011/08/23/enable-webgl-in-safari">enable WebGL manually</a>. If you use iOS Safari, you cannot use WebGL. If you use Android, please try <a href="http://www.mozilla.org/en-US/mobile/">Firefox Mobile</a> or <a href="https://play.google.com/store/apps/details?id=com.opera.browser&hl=en">Opera Mobile</a></p>')

        container.append('<p>Please consult the <a href="http://support.google.com/chrome/bin/answer.py?hl=en&answer=1220892">support pages</a> on how to get WebGL for your machine.</p>')
