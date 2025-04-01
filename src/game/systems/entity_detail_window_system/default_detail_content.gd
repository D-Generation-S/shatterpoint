class_name DefaultDetailContent extends Control

@export var _content_name: TranslationResource

func set_content_name(new_name: TranslationResource):
	_content_name = new_name

func get_content_name() -> String:
	return _content_name.key

