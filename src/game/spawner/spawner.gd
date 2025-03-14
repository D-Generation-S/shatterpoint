class_name Spawner extends PathFollow2D

signal spawning_completed()
signal spawning_started()

@export var overlay: ResourceOverlay
@export var enemy_root_node: Node

@onready var enemy_template: PackedScene = load("res://scenes/game/templates/EnemyTemplate.tscn")
@export var spawn_information: SpawnInformation

var timer: Timer
var did_spawn_enemy: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = PROCESS_MODE_DISABLED
	timer = Timer.new()
	timer.autostart = false
	timer.wait_time = spawn_information.spawn_intervall_in_seconds
	timer.timeout.connect(spawn_enemy)
	add_child(timer)

func spawn_enemy():
	var valid_entries = spawn_information.spawn_sets.filter(func(data_set): return data_set.amount > 0)
	if valid_entries.size() == 0:
		spawning_completed.emit()
		timer.stop()
		return
	if !did_spawn_enemy:
		did_spawn_enemy = true
		spawning_started.emit()
	var entry = valid_entries[randi_range(0, valid_entries.size() - 1)]
	progress_ratio = randf()
	var enemy = enemy_template.instantiate() as Enemy
	enemy.global_position = global_position
	enemy.died.connect(overlay.add_scrap)
	enemy.reached_town.connect(overlay.take_city_damage)
	enemy_root_node.add_child(enemy)
	enemy.activate.call_deferred()
	entry.amount -= 1


func ready_up():
	did_spawn_enemy = false
	process_mode = PROCESS_MODE_INHERIT
	timer.start()

func disable():
	process_mode = PROCESS_MODE_DISABLED
	if timer != null:
		timer.stop()