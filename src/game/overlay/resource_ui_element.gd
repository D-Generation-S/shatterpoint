@tool
class_name ResourceUiElement extends Control

signal image_changed(new_texture: Texture)
signal name_changed(new_name: String, new_description: String, icon: Texture)
signal value_changed(new_value: int)
signal max_value_has_changed(amount: int)
signal update_tooltip(current_value: int, max_value: int)

var current_value: int
var max_storage: int

@export var resource_texture: Texture:
	set(value):
		resource_texture = value
		image_changed.emit(resource_texture)

@export_enum("SCRAP", "ENERGY") var resource_name: String = "SCRAP":
	set(value):
		resource_name = value
		name_changed.emit(resource_name, resource_name + "_DESCRIPTION", resource_texture)
		
@export var initial_value: int:
	set(value):
		initial_value = value
		update_value(initial_value)

func _ready():
	image_changed.emit(resource_texture)
	name_changed.emit(resource_name, resource_name + "_DESCRIPTION", resource_texture)
	update_value(initial_value)

func update_value(new_value: int):
	current_value = new_value
	value_changed.emit(current_value)
	update_tooltip.emit(current_value, max_storage)

func set_max_value(amount: int):
	max_storage = amount
	max_value_has_changed.emit(amount)
	update_tooltip.emit(current_value, max_storage)
		