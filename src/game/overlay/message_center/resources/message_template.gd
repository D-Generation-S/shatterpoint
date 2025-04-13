class_name MessageTemplateResource extends Resource

## Make enum!
@export_enum("Top Left", "Top Center", "Top Right", "Center Left", "Center", "Center Right", "Bottom Left", "Bottom Center", "Bottom Right") var position: int
@export var style: MessageStyle
@export var icon: Texture
@export var time_to_show: float = 1

@export var _text: TranslationResource
var _prepared_text: String

func prepare_text(parameters: Array[String]):
	_prepared_text = tr(_text.key) % parameters

func get_prepared_text() -> String:
	if _prepared_text != "":
		return _prepared_text
	return tr(_text.key)

func get_position() -> int:
	match position:
		4:
			return MessagePosition.CENTER
		7:
			return MessagePosition.BOTTOM
		8:
			return MessagePosition.BOTTOM_RIGHT
	return position