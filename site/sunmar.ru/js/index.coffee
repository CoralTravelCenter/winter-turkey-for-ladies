window.ASAP = (->
    fns = []
    callall = () ->
        f() while f = fns.shift()
    if document.addEventListener
        document.addEventListener 'DOMContentLoaded', callall, false
        window.addEventListener 'load', callall, false
    else if document.attachEvent
        document.attachEvent 'onreadystatechange', callall
        window.attachEvent 'onload', callall
    (fn) ->
        fns.push fn
        callall() if document.readyState is 'complete'
)()

log = () ->
    if window.console and window.DEBUG
        console.group? window.DEBUG
        if arguments.length == 1 and Array.isArray(arguments[0]) and console.table
            console.table.apply window, arguments
        else
            console.log.apply window, arguments
        console.groupEnd?()
trouble = () ->
    if window.console
        console.group? window.DEBUG if window.DEBUG
        console.warn?.apply window, arguments
        console.groupEnd?() if window.DEBUG

window.preload = (what, fn) ->
    what = [what] unless  Array.isArray(what)
    $.when.apply($, ($.ajax(lib, dataType: 'script', cache: true) for lib in what)).done -> fn?()

window.queryParam = queryParam = (p, nocase) ->
    params_kv = location.search.substr(1).split('&')
    params = {}
    params_kv.forEach (kv) -> k_v = kv.split('='); params[k_v[0]] = k_v[1] or ''
    if p
        if nocase
            return decodeURIComponent(params[k]) for k of params when k.toUpperCase() == p.toUpperCase()
            return undefined
        else
            return decodeURIComponent params[p]
    params

String::zeroPad = (len, c) ->
    s = ''
    c ||= '0'
    len ||= 2
    len -= @length
    s += c while s.length < len
    s + @
Number::zeroPad = (len, c) -> String(@).zeroPad len, c

ASAP ->

    $('[data-content-marker]').on 'click', (e) ->
        $this = $(this)
        marker = $this.attr 'data-content-marker'
        $block2show = $("[data-content='#{ marker }']")
        $block2show.addClass('shown').siblings('.shown').removeClass('shown')
        $this.addClass('selected').siblings('.selected').removeClass('selected')
        setTimeout ->
            $('.flickity-enabled').flickity 'resize'
        , 100
        setTimeout ->
            $('.flickity-enabled').flickity 'resize'
        , 1000
        setTimeout ->
            $block2show.find('.cards-grid').data('isotope')?.arrange()
        , 100

    $hotels = $('[data-component-instance]')
    $('.resort').each (idx, el) ->
        $resort = $(el)
        $hotels_set_widgetcontainer = $hotels.eq(idx).closest('.widgetcontainer')
        $resort.append($('<div/>').append($hotels_set_widgetcontainer.children()))
        $hotels_set_widgetcontainer.remove()

    preload 'https://cdnjs.cloudflare.com/ajax/libs/flickity/2.3.0/flickity.pkgd.min.js', ->
        $('.mobi-slider').flickity
            watchCSS: yes
            cellSelector: '.info-comp'
            cellAlign: 'center'
            wrapAround: yes
        setTimeout ->
            $('.flickity-enabled').flickity 'resize'
        , 100
