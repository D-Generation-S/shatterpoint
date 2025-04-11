class_name ExplainRichTextLabel extends RichTextLabel

@export var inside_of_popup: bool = false

var _offset: Vector2 = Vector2.ZERO

func _init():
    process_mode = Node.PROCESS_MODE_ALWAYS
    meta_clicked.connect(_explanation_requested)

func set_tooltip_offset(new_offset: Vector2):
    _offset = new_offset

func _explanation_requested(meta: Variant):
    var data = String(meta)
    var tooltip_position =  get_viewport().get_mouse_position()
    if inside_of_popup:
        tooltip_position = get_tree().root.get_viewport().get_mouse_position()
    tooltip_position += _offset
    GlobalExplainTooltip.show_tooltip(tooltip_position, data.to_snake_case().to_upper())