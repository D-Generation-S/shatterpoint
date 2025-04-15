@tool
class_name Tag extends Resource

@export var _name: TranslationResource:
	set(value):
		if value == null:
			_name = null
			key = ""
			return
			
		_name = value
		key = value.key
@export var key: String
@export var _explanation_box: TooltipData
@export var _color: Color

func get_key() -> String:
	if key == null:
		if _name != null:
			return _name.key
		return ""
	return key
	
func get_display_name() -> String:
	return _name.key

func get_explanation() -> TooltipData:
	return _explanation_box

func get_color() -> Color:
	if _color == null:
		return Color.GRAY
	return _color

func is_equal(tag: Tag) -> bool:
	return tag.get_key() == get_key()
