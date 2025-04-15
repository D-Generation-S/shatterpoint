class_name TagTemplate extends Control

signal text_changed(text: String)
signal color_changed(color: Color)
signal explanation_changed(key: String)

func setup(tag: Tag):
	text_changed.emit(tag.get_display_name())
	color_changed.emit(tag.get_color())
	if tag.get_explanation() != null:
		explanation_changed.emit(tag.get_explanation().key)