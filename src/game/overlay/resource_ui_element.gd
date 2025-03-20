@tool
class_name ResourceUiElement extends Control

signal image_changed(new_texture: Texture)
signal name_changed(new_name: String, new_description: String, icon: Texture)
signal value_changed(new_value: int)

@export var resource_texture: Texture:
	set(value):
		resource_texture = value
		image_changed.emit(resource_texture)

@export_enum("SCRAP", "ENERGY") var resource_name: String = "SCRAP":
	set(value):
		resource_name = value
		name_changed.emit(resource_name, resource_name + "_DESCRIPTION", resource_texture)
		
@export var inital_value: int:
	set(value):
		inital_value = value
		update_value(inital_value)

func _ready():
	image_changed.emit(resource_texture)
	name_changed.emit(resource_name, resource_name + "_DESCRIPTION", resource_texture)
	update_value(inital_value)

func update_value(new_value: int):
	value_changed.emit(new_value)