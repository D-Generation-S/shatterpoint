extends Node2D

@export var map: TileMapLayer

func _process(_delta):
	var mouse_position = get_viewport().get_canvas_transform().affine_inverse() * get_viewport().get_mouse_position()
	var local_map_pos = map.local_to_map(map.to_local(mouse_position))
	global_position = map.to_global(map.map_to_local(local_map_pos))
