extends Node2D

@export var is_active: bool = false
@export var min_selection_size: float = 20.0
@export var outline_color: Color = Color(1, 1, 1)
@export var fill_color: Color = Color(0, 0, 0, 0.5)
@export var outline_width: float = 2.0

var currently_selecting: bool = false
var selection_start: Vector2
var selection_end: Vector2

func _init():
    z_index = 1000

func build_mode_changed(in_build_mode: bool):
    is_active = in_build_mode
    if !in_build_mode:
        enable()
    else:
        disable()

func _process(_delta):
    if Input.is_action_pressed("interact"):
        if !currently_selecting:
            selection_start = get_global_mouse_position()

        selection_end = get_global_mouse_position()
        queue_redraw()
        currently_selecting = true
    if Input.is_action_just_released("interact"):
        if !currently_selecting:
            return
        currently_selecting = false
        queue_redraw()
        make_selection()

func make_selection():
    var global_top_left = to_global(get_top_left())
    var global_bottom_right = to_global(get_bottom_right())
    var area = Rect2(global_top_left, global_bottom_right - global_top_left)
    var valid_entries = get_tree().get_nodes_in_group("selectable").filter(func(entry): return entry is Node2D and area.has_point(entry.global_position))
    reset_selection()
    for valid_entry in valid_entries:
        if valid_entry is Enemy:
            valid_entry.was_selected()
    
func reset_selection():
    for entry in get_tree().get_nodes_in_group("selectable"):
        if entry is Enemy:
            entry.was_deselected()

func _draw():
    if !is_active or !currently_selecting:
        return
    draw_rect(Rect2(get_top_left(), get_bottom_right() - get_top_left()), fill_color, true)
    draw_line(get_top_left(), get_top_right(), outline_color, outline_width)
    draw_line(get_top_left(), get_bottom_left(), outline_color, outline_width)
    draw_line(get_bottom_left(), get_bottom_right(), outline_color, outline_width)
    draw_line(get_bottom_right(), get_top_right(), outline_color, outline_width)
    
func get_top_left() -> Vector2:
    var min_x = min(selection_start.x, selection_end.x)
    var min_y = min(selection_start.y, selection_end.y)
    return Vector2(min_x, min_y)

func get_top_right() -> Vector2:
    var max_x = max(selection_start.x, selection_end.x)
    var min_y = min(selection_start.y, selection_end.y)
    return Vector2(max_x, min_y)

func get_bottom_left() -> Vector2:
    var min_x = min(selection_start.x, selection_end.x)
    var max_y = max(selection_start.y, selection_end.y)
    return Vector2(min_x, max_y)

func get_bottom_right() -> Vector2:
    var max_x = max(selection_start.x, selection_end.x)
    var max_y = max(selection_start.y, selection_end.y)
    return Vector2(max_x, max_y)

func enable():
    is_active = true
    process_mode = PROCESS_MODE_INHERIT

func disable():
    is_active = false
    process_mode = PROCESS_MODE_DISABLED
    reset_selection()
    queue_redraw()