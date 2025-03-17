@tool
extends TextureRect

@export var in_tool_mode: bool = true
@export var tooltip_template: PackedScene = preload("res://scenes/game/overlay/tooltips/resource_bar_tooltip_template.tscn")

var tooltip_description: String
var tooltip_icon: Texture

func set_new_image(new_image: Texture):
	if Engine.is_editor_hint() and not in_tool_mode:
		return
	texture = new_image

func name_changed(new_name: String, new_description: String, icon: Texture):
	tooltip_text = tr(new_name)
	tooltip_description = tr(new_description)
	tooltip_icon = icon

func _make_custom_tooltip(for_text) -> Object:
	var template = tooltip_template.instantiate() as CustomTooltip
	template.setup(for_text, tooltip_description, tooltip_icon)
	return template
