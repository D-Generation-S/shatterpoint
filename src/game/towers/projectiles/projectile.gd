class_name Projectile extends CharacterBody2D

signal sticker_requested(sticker_position: Vector2, icon: Texture)

@export var speed: float
@export var base_move_direction: Vector2 = Vector2.RIGHT
@export var min_time_to_live_in_seconds: float = 3
@export var max_time_to_live_in_seconds: float = 10

@onready var icon_node: Sprite2D = $"%Visuals"

var initial_position: Vector2
var visual_effect_container: Node
var target_node: Node2D
var carried_damage: float
var armor_penetration: float
var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	icon_node.visible = false
	global_position = initial_position
	base_move_direction = base_move_direction.normalized()
	process_mode = PROCESS_MODE_DISABLED

	for system in get_tree().get_nodes_in_group("system"):
		if system is StickerSystem:
			sticker_requested.connect(system.request_sticker_at_position)

	timer = Timer.new()
	timer.autostart = false
	var time_to_live = randf_range(min_time_to_live_in_seconds, max_time_to_live_in_seconds)
	timer.wait_time = time_to_live
	timer.timeout.connect(_timeout)
	add_child(timer)
	_start_live_time_animation(time_to_live, icon_node)

	timer.start()

func _start_live_time_animation(_time_to_live: float, _visuals: Sprite2D):
	pass

func _trigger_lifetime_end_effect(_current_position: Vector2, _effect_target_node: Node2D):
	pass

func setup(
	global_start_position: Vector2,
	target: Node2D,
	damage: float,
	penetration: float,
	visual_effect_container: Node):
	initial_position = global_start_position
	target_node = target
	carried_damage = damage
	armor_penetration = penetration
	self.visual_effect_container = visual_effect_container

func _calculate_impact_point(target: EntityWithStats) -> Vector2:
	return target.global_position

func fire():
	icon_node.visible = true
	var calculated_impact = _calculate_impact_point(target_node)
	look_at(calculated_impact)
	velocity = base_move_direction.rotated(rotation).normalized() * speed
	process_mode = PROCESS_MODE_PAUSABLE

func _process(_delta):
	move_and_slide()

func _on_collision_entered(body: Node2D):
	if body is Enemy:
		body.deal_damage(carried_damage)

	queue_free()


func _timeout():
	_trigger_lifetime_end_effect(global_position, visual_effect_container)
	queue_free()
