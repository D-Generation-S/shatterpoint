class_name ResourceOverlay extends CanvasLayer

signal message_requested(target: int, type: MessageType, message: String, duration: float, icon: Texture)
signal scrap_updated(new_value: int)
signal power_updated(new_value: float)
signal max_power_updated(new_value: float)
signal set_max_health(min: int, max: int)
signal hp_updated(new_value: int)
signal game_lost()

@export var scrap_icon: Texture
@export var energy_icon: Texture
@export var resource_got_message_type: MessageStyle
@export var resource_lost_message_type: MessageStyle

#The base amount of power that can be stored
@export var base_power: float = 50

@export var scrap_animation_node: Node2D
@export var power_animation_node: Node2D

@export var _resource_data: ResourceData

func _ready():
	_resource_data.startup()
	scrap_updated.emit(_resource_data.get_scrap())
	set_max_health.emit(0, _resource_data.get_hp())
	hp_updated.emit(_resource_data.get_hp())
	recalculate_max_power()

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

func add_power(value: float):
	_resource_data.change_power(value)
	power_updated.emit(_resource_data.get_power())
	pass

func take_city_damage(value: int):
	_resource_data.change_hp(-value)
	hp_updated.emit(_resource_data.get_hp())
	if _resource_data.get_hp() <= 0:
		game_lost.emit()

func get_resource_data() -> ResourceData:
	var duplicated_resource = _resource_data.duplicate() as ResourceData
	duplicated_resource.change_hp(_resource_data.get_hp() - duplicated_resource.get_hp())
	duplicated_resource.change_scrap(_resource_data.get_scrap() - duplicated_resource.get_scrap())
	return duplicated_resource

func get_power():
	return _resource_data.get_power()

func recalculate_max_power():
	var new_max_power = base_power

	max_power_updated.emit(new_max_power)
	_resource_data.set_max_power(new_max_power)

func get_scrap():
	return _resource_data.get_scrap()