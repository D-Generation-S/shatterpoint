class_name ResourceOverlay extends CanvasLayer

signal message_requested(target: int, type: MessageType, message: String, duration: float, icon: Texture)
signal scrap_updated(new_value: int)
signal set_max_health(min: int, max: int)
signal hp_updated(new_value: int)
signal game_lost()

@export var scrap_icon: Texture
@export var resource_got_message_type: MessageStyle
@export var resource_lost_message_type: MessageStyle

@export var _resource_data: ResourceData

func _ready():
	_resource_data = ResourceData.new()
	scrap_updated.emit(_resource_data.get_scrap())
	set_max_health.emit(0, _resource_data.get_hp())
	hp_updated.emit(_resource_data.get_hp())

func add_scrap(value: int):
	_resource_data.change_scrap(value)
	scrap_updated.emit(_resource_data.get_scrap())

	var new_scrap_message = tr("SCRAP_RECIEVED")
	var message_style = resource_got_message_type
	if value < 0:
		new_scrap_message = tr("SCRAP_LOST")
		message_style = resource_lost_message_type
	new_scrap_message = new_scrap_message.replace("%AMOUNT%", str(value))
	
	if value != 0:
		message_requested.emit(MessagePosition.BOTTOM_RIGHT, message_style, new_scrap_message, 4.0, scrap_icon)
	
func take_city_damage(value: int):
	_resource_data.change_hp(-value)
	hp_updated.emit(_resource_data.get_hp())
	if _resource_data.get_hp() <= 0:
		game_lost.emit()

func get_resource_data() -> ResourceData:
	var duplicate = _resource_data.duplicate() as ResourceData
	duplicate.change_hp(_resource_data.get_hp() - duplicate.get_hp())
	duplicate.change_scrap(_resource_data.get_scrap() - duplicate.get_scrap())
	return duplicate

func get_scrap():
	return _resource_data.get_scrap()