class_name ResourceOverlay extends CanvasLayer

signal message_requested(target: int, type: MessageType, message: String, duration: float, icon: Texture)
signal scrap_updated(new_value: int)
signal max_scrap_updated(new_value: int)
signal power_updated(new_value: float)
signal max_power_updated(new_value: float)
signal set_max_health(min: int, max: int)
signal hp_updated(new_value: int)
signal game_lost()

@export var scrap_icon: Texture
@export var energy_icon: Texture
@export var generator_group: String = "generator"
@export var scrap_group: String = "storage"
@export var resource_got_message_type: MessageStyle
@export var resource_lost_message_type: MessageStyle

@export var scrap_animation_node: Node2D
@export var power_animation_node: Node2D

@export var _resource_data: ResourceData

func _ready():
	_resource_data.startup()
	scrap_updated.emit(_resource_data.get_scrap())
	set_max_health.emit(0, _resource_data.get_hp())
	hp_updated.emit(_resource_data.get_hp())
	recalculate_resource_limit()

	GlobalMessageLine.building_added.connect(building_was_added)
	GlobalMessageLine.building_removed.connect(building_was_destroyed)

	_add_commands()

func add_scrap(value: int):
	if value == 0:
		return
	var total_scrap = _resource_data.get_scrap() + value
	var difference = _resource_data.get_max_scrap() - total_scrap
	if difference < 0:
		value += difference
	_resource_data.change_scrap(value)
	scrap_updated.emit(_resource_data.get_scrap())

	if value == 0:
		message_requested.emit(MessagePosition.BOTTOM_RIGHT, resource_lost_message_type, tr("NOT_ENOUGH_STORAGE"), 4.0, scrap_icon)
		return

	var new_scrap_message = tr("SCRAP_RECEIVED")
	var message_style = resource_got_message_type
	if value < 0:
		new_scrap_message = tr("SCRAP_LOST")
		message_style = resource_lost_message_type
	new_scrap_message = new_scrap_message % value
	
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
	
func recalculate_resource_limit():
	recalculate_max_scrap()
	recalculate_max_power()

func recalculate_max_scrap():
	var new_max_scrap = _get_scrap_storage_from_buildings()
	var scrap_change = new_max_scrap - _resource_data.get_max_scrap()
	if scrap_change == 0:
		return
	var message_style = resource_got_message_type	
	var message = tr("TOTAL_SCRAP_RECEIVED")
	if scrap_change < 0:
		message = tr("TOTAL_SCRAP_LOST")
		message_style = resource_lost_message_type

	message = message % scrap_change

	message_requested.emit(MessagePosition.BOTTOM_RIGHT, message_style, message, 4.0, energy_icon)

	var percentage_remains = 1
	if _resource_data.get_max_scrap() != 0:
		percentage_remains = new_max_scrap / float(_resource_data.get_max_scrap())
	var scrap_lost_percentage: float = 0
	if percentage_remains < 1:
		scrap_lost_percentage = 1 - percentage_remains
	
	var scrap_to_remove = _resource_data._scrap * scrap_lost_percentage
	add_scrap(-scrap_to_remove)
		
	max_scrap_updated.emit(new_max_scrap)
	_resource_data.set_max_scrap(new_max_scrap)

func recalculate_max_power():
	var new_max_power = _get_power_storage_from_buildings()
	var power_change = new_max_power - _resource_data.get_max_power()
	if power_change == 0:
		return
	var message_style = resource_got_message_type
	var message = tr("TOTAL_ENERGY_RECEIVED")
	if power_change < 0:
		message = tr("TOTAL_ENERGY_LOST")
		message_style = resource_lost_message_type

	message = message % power_change
	
	message_requested.emit(MessagePosition.BOTTOM_RIGHT, message_style, message, 4.0, energy_icon)

	var percentage_remains = new_max_power / _resource_data.get_max_power()
	var power_lost_percentage: float = 0
	if percentage_remains < 1:
		power_lost_percentage = 1 - percentage_remains
	
	var power_to_remove = _resource_data._power * power_lost_percentage
	add_power(-power_to_remove)
		
	max_power_updated.emit(new_max_power)
	_resource_data.set_max_power(new_max_power)

func _get_active_buildings_in_group(group: String) -> Array[Node]:
	return get_tree().get_nodes_in_group(group).filter(func(building): return !building.is_queued_for_deletion())

func _get_power_storage_from_buildings() -> float:
	var return_power: float = 0
	var generators = _get_active_buildings_in_group(generator_group)
	for generator in generators:
		if generator is Building:
			var stats = generator.building_data
			if stats is GeneratorData:
				return_power += stats.storage_capacity

	return return_power

func _get_scrap_storage_from_buildings() -> int:
	var return_scrap: int = 0
	var scrap_storages = _get_active_buildings_in_group(scrap_group)
	for scrap_storage in scrap_storages:
		if scrap_storage is Building:
			var stats = scrap_storage.building_data
			if stats is StorageData:
				return_scrap += stats.storage_capacity
	return return_scrap

func building_was_added(_building: Building):
	recalculate_resource_limit()

func building_was_destroyed(_building: Building):
	recalculate_resource_limit()

func get_scrap():
	return _resource_data.get_scrap()


func _add_commands():
	Console.register_custom_command("add scrap", add_scrap_command, ["(int) scrap amount"])
	Console.register_custom_command("damage_health", _damage_city_health, ["(int) damage points"], "Damage the player city", "", ["damage_health 5"])
	

func _damage_city_health(damage: String):
	if !damage.is_valid_int():
		return "[color=red]The damage value was not a valid int[/color]"
	take_city_damage(int(damage))
	pass
func add_scrap_command(scrap: String):
	if scrap.is_valid_int():
		add_scrap(int(scrap))

func _exit_tree():
	Console.remove_command("add scrap")
