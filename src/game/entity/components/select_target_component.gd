extends Node2D

signal set_move_command(new_position: Vector2)

@export_enum("ground_target") var target_group: String = "ground_target"

func _ready():
	await get_tree().physics_frame
	set_target.call_deferred()

func set_target():
	var targets = get_tree().get_nodes_in_group(target_group) as Array[Node2D]
	if targets.size() == 0:
		printerr("No targets can be found!")
		return
	set_move_command.emit(targets.pick_random().global_position)