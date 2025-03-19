extends Node

@export var scrap_resource_trave_node: Node2D
@export var resource_path_template: PackedScene


func create_new_travel_path(icon: Texture, start_node: Node2D, end_node: Node2D, amount: int, time: float):
	var animation = resource_path_template.instantiate() as ResourcePathAnimation
	
	if !end_node.is_node_ready():
		animation.add_child(end_node)

	if !start_node.is_node_ready():
		animation.add_child(start_node)

	animation.icon = icon
	animation.start_point = start_node
	animation.end_point = end_node
	animation.travel_time = time
	animation.number_of_items = amount
	add_child(animation)
