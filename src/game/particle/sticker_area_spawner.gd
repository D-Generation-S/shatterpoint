@tool
extends Node2D

signal all_stickers_despawned()

@export_group("Area and visuals")
@export var possible_textures: Array[Texture]
@export var radius: float = 5:
	set(value):
		radius = value
		queue_redraw()

@export_group("Amount")
@export var min_amount: int = 1
@export var max_amount: int = 1

var spawners: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var number_to_spawn = randi_range(min_amount, max_amount)
	var sticker_system = GlobalDataAccess.get_sticker_system()
	if sticker_system == null:
		_all_spawned_and_vanished()
		return
	for count in range(number_to_spawn):
		var action = DelayedAction.new(randf_range(0.1, 0.6), spawn_sticker)
		add_child(action)
		spawners += 1
		action.tree_exited.connect(_spawner_left)

func spawn_sticker():
	var sticker_system = GlobalDataAccess.get_sticker_system()
	var sticker_position = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
	sticker_system.request_sticker_at_position(to_global(sticker_position), possible_textures.pick_random())

func _all_spawned_and_vanished():
	all_stickers_despawned.emit()
	queue_free()

func _spawner_left():
	spawners -= 1
	if spawners == 0:
		_all_spawned_and_vanished()

func _draw():
	if Engine.is_editor_hint():
		draw_circle(position, radius, Color(1.0 ,0 ,0 ,0.5))
