@tool
class_name ChangeableLabel extends Label

@export var should_translate: bool = true
@export var in_tool_mode: bool = true

func set_new_label(new_text: String):
	if Engine.is_editor_hint() and not in_tool_mode:
		return
	if should_translate:
		new_text = tr(new_text)

	text = new_text
