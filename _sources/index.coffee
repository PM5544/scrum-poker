body = document.body
bodyClasses = body.classList
selected = 'selected'
surprise = 'surprise'
ar = Array.prototype
lastClicked = null
filterFn = (el) ->
    `!(lastClicked == el)`

body.addEventListener(
    'touchstart'
    (e) ->

        target = e.target

        if this is target or target.nodeName is 'BUTTON'
            return

        if target.nodeName is 'SPAN'
            target = target.parentNode

        lastClicked = target
        targetClassList = target.classList

        wasSelected = targetClassList.contains selected
        allSelected = ar.slice.call( body.querySelectorAll( "." + selected ) ).filter filterFn
        allSelected.forEach (elem) ->
            elem.classList.remove selected

        if target.classList.contains selected and target.classList.contains surprise
            target.classList.remove surprise
        else if not target.classList.contains selected
            targetClassList.add selected
            targetClassList.add surprise
        else if target.classList.contains surprise
            targetClassList.remove surprise
        else
            targetClassList.toggle selected

        undefined
)

body.addEventListener(
    'transitionend'
    (e) ->
)

if fullScreen and fullScreen.fullScreenEnabled
    button = document.querySelector 'button'
    fullScreen.addEventListener button, 'click', body
