keymap = ({
    87: 'w',
    65: 'a',
    83: 's',
    68: 'd',
    81: 'q',
    69: 'e',
    37: 'left',
    39: 'right',
    38: 'up',
    40: 'down',
    13: 'enter',
    27: 'esc',
    32: 'space',
    8: 'backspace',
    16: 'shift',
    17: 'ctrl',
    18: 'alt',
    91: 'start',
    0: 'altc',
    20: 'caps',
    9: 'tab',
    49: 'key1',
    50: 'key2',
    51: 'key3',
    52: 'key4'
})

keys = {}

$(document).keydown (event) ->
    name = keymap[event.which]
    keys[name] = true

$(document).keyup (event) ->
    name = keymap[event.which]
    keys[name] = false

return keys
