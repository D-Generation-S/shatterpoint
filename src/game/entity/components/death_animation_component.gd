extends Node2D

@export var root_node_to_get_parent_from: Node2D
var scene_to_play_on_death: PackedScene


func data_updated(death_scene: PackedScene):
	scene_to_play_on_death = death_scene

func dying():
	if scene_to_play_on_death == null:
		return
	
	var scene = scene_to_play_on_death.instantiate() as Node2D
	scene.global_position = global_position
	root_node_to_get_parent_from.get_parent().add_child(scene)

