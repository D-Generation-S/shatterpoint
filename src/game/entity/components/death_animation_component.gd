extends Node2D

@export var root_node_to_get_parent_from: Node2D
var scene_to_play_on_death: PackedScene

var texture_to_use: Texture = null

func visuals_to_set(texture: Texture):
	texture_to_use = texture

func data_updated(death_scene: PackedScene):
	scene_to_play_on_death = death_scene

func dying():
	if scene_to_play_on_death == null:
		return
	
	var scene = scene_to_play_on_death.instantiate() as ConditionalEntityDestruct
	scene.global_position = global_position
	if texture_to_use != null:
		scene.add_texture(texture_to_use)
	root_node_to_get_parent_from.get_parent().add_child(scene)
