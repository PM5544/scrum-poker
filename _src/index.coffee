# setup and variable instantiation
body = document.body
bodyClasses = body.classList
reactToShake = false
selectedElement = null
index = 0

steps = [
    () -> #0
        body.className = 'animate fadingOut'

    () -> #1
        body.className = 'fadedOut'
        selectedElement.className = 'beforeSurprise'
        reactToShake = true

    () -> #2
        body.className = 'animate fadedOut'
        selectedElement.className = 'afterSurprise'

    () -> #3
        undefined #showing the number now

    () -> #4
        selectedElement.className = 'beforeSurprise'

    () -> #5
        body.className = 'animate fadingOut'
        selectedElement.className = ''
        window.setTimeout(
            ()->
                executeStep()
        ,   300
        )

    () -> #6
        body.className = 'animate';
        selectedElement = null
]

# functoinal part
executeStep = () ->
    steps[ index ]()
    if not steps[ ++index ]
        index = 0


transitionEnd = (e) ->
    if not (e.target is selectedElement) or not(e.propertyName is 'opacity')
        return

    executeStep()


touchStart = (e) ->

    target = e.target

    if reactToShake
        reactToShake = false
        executeStep()
        return

    if this is target or target.nodeName is 'BUTTON'
        return

    if target.parentNode.nodeName is 'DIV'
        target = target.parentNode

    selectedElement = target

    executeStep()


deviceMotion = (e) ->
    if reactToShake and e.acceleration.x > 10
        reactToShake = false
        executeStep()


body.addEventListener 'touchstart', touchStart, false
body.addEventListener 'transitionend', transitionEnd, false
body.addEventListener 'webkitTransitionEnd', transitionEnd, false
window.addEventListener "devicemotion", deviceMotion , false
window.addEventListener "webkitDevicemotion", deviceMotion , false
