extends Node2D

var _currently_selected: bool = false

signal move_command_issued(position: Vector2)
signal show_selected_sprite()
signal hide_selected_sprite()

func _ready():
    selection_changed(false)

func _process(_delta):
    if Input.is_action_just_pressed("command_move"):
        var mouse_position = get_global_mouse_position()
        move_command_issued.emit(mouse_position)
    pass

func selection_changed(selected: bool):
    _currently_selected = selected
    if _currently_selected:
        process_mode = PROCESS_MODE_INHERIT
        show_selected_sprite.emit()
    else:
        process_mode = PROCESS_MODE_DISABLED
        hide_selected_sprite.emit()