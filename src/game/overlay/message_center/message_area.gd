class_name MessageArea extends CanvasLayer
@export var message_center_group: String = "message_center"
@export var default_message_style: MessageStyle


var message_centers: Array[MessageCenter] = []

func _ready():
	for message_center in get_tree().get_nodes_in_group(message_center_group):
		if message_center is MessageCenter:
			message_centers.append(message_center)

func add_simple_message(target: int, message: String, time_to_show: float):
	add_new_message(target, default_message_style, message, time_to_show)

func add_simple_styled_message(target: int, style: MessageStyle, message: String, time_to_show: float):
	add_new_message(target, style, message, time_to_show)

func add_new_message(target: int, style: MessageStyle, message: String, time_to_show: float, message_icon: Texture = null):
	var message_target: MessageCenter = message_centers.filter(func(center: MessageCenter): return center.get_position() == target).pop_front()

	if message_target == null:
		printerr("Could not get any message template for requested message area: " + str(target))
		return

	message_target.add_new_message(style, message, time_to_show, message_icon)

