class_name StickerSystem extends Node

@export var root_sticker_node: Node2D
@export var start_alpha: float = 0.5

@export var min_time_to_life: float
@export var max_time_to_life: float

func request_sticker_at_position(global_sticker_position: Vector2, icon: Texture):
	var sticker = Sticker.new(global_sticker_position, icon, randf_range(min_time_to_life, max_time_to_life), start_alpha)
	root_sticker_node.add_child(sticker)

func clear_stickers():
	for sticker in root_sticker_node.get_children():
		sticker.queue_free()