@tool
extends TextureRect

@export var in_tool_mode: bool = true


func set_new_image(new_image: Texture):
	if Engine.is_editor_hint() and not in_tool_mode:
		return

	texture = new_image
