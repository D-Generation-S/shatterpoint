@tool
extends TextureRect

@export var in_tool_mode: bool = true
@export var tooltip_template: PackedScene = preload("res://scenes/game/overlay/tooltips/resource_bar_tooltip_template.tscn")

var tooltip_key: String
var tooltip_description: String
var tooltip_icon: Texture

func set_new_image(new_image: Texture):
	if Engine.is_editor_hint() and not in_tool_mode:
		return
	texture = new_image

func name_changed(new_name: String, new_description: String, icon: Texture):
	tooltip_key = new_name
	tooltip_text = tr(new_name)
	tooltip_description = tr(new_description)
	tooltip_icon = icon

func _make_custom_tooltip(for_text) -> Object:
	GlobalExplainTooltip.show_tooltip(global_position, tooltip_key)

	var dummy = Label.new()
	dummy.tooltip_text = ""
	dummy.visible = false
	dummy.queue_free()
	return dummy
