class_name MessageCenter extends Node

@export var message_template: PackedScene
@export var node_to_hide: Control
@export var message_target: Control
@export var put_as_first: bool = true
@export var number_of_allowed_message: int = 1

@export var message_group: String = "message"

@export_enum("Center:0", "Bottom_Right:1", "Bottom:2") var message_position: int

var message_queue: Array[MessageTemplate] = []

func hide_area():
	node_to_hide.visible = false

func show_area():
	node_to_hide.visible = true

func get_position() -> int:
	return message_position

func clear_all_messages():
	printerr("Not implemented")

func add_new_message(message: String, time_to_show: float, message_icon: Texture = null):
	var message_node = message_template.instantiate() as MessageTemplate
	message_node.add_to_group(message_group)
	message_node.setup(message, time_to_show, message_icon)
	_add_message(message_node)

func _add_message(template: MessageTemplate):
	template.message_vanished.connect(_handle_message_vanished)
	message_queue.append(template)
	_handle_message_vanished()

func _handle_message_vanished():
	var active_messages = get_children().filter(func(child): return !child.is_queued_for_deletion() and child.is_in_group("message")).size()
	if active_messages == 0:
		hide_area()
	if message_queue.size() == 0:
		return

	if active_messages >= number_of_allowed_message:
		return

	var new_message = message_queue.pop_front()
	add_child(new_message)
	show_area()
	
