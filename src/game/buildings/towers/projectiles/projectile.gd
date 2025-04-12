class_name Projectile extends CharacterBody2D

signal sticker_requested(sticker_position: Vector2, icon: Texture)
signal update_collision_mask(new_mask: int)
signal update_layer_mask(new_mask: int)

@export_group("Audio")
@export var fire_sound: AudioStream
@export var hit_sound: AudioStream
@export var decay_sound: AudioStream

@export_group("Movement")
@export var speed: float
@export var base_move_direction: Vector2 = Vector2.RIGHT
@export_group("Lifetime")
@export var min_time_to_live_in_seconds: float = 3
@export var max_time_to_live_in_seconds: float = 10

@onready var icon_node: Sprite2D = $"%Visuals"

var initial_position: Vector2
var target_node: Node2D
var carried_damage: float
var armor_penetration: float
var carried_modifiers: Array[StatModifier]
var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	icon_node.visible = false
	global_position = initial_position
	base_move_direction = base_move_direction.normalized()
	process_mode = PROCESS_MODE_DISABLED

	var sticker_system = GlobalDataAccess.get_sticker_system()
	sticker_requested.connect(sticker_system.request_sticker_at_position)

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

func _trigger_lifetime_end_effect(_current_position: Vector2):
	GlobalSoundManager.play_sound_at_position(global_position, decay_sound, 2000, randf_range(0.8, 1.2))

func setup(
	global_start_position: Vector2,
	target: Node2D,
	damage: float,
	penetration: float,
	modifiers: Array[StatModifier] = []):
	initial_position = global_start_position
	target_node = target
	carried_damage = damage
	armor_penetration = penetration
	carried_modifiers = modifiers

func _calculate_impact_point(target: EntityWithStats) -> Vector2:
	return target.global_position

func fire():
	icon_node.visible = true
	var calculated_impact = _calculate_impact_point(target_node)
	look_at(calculated_impact)
	velocity = base_move_direction.rotated(rotation).normalized() * speed
	process_mode = PROCESS_MODE_PAUSABLE

	GlobalSoundManager.play_sound_at_position(global_position, fire_sound, 2000, randf_range(0.8, 1.2))

func _process(_delta):
	move_and_slide()

func _on_collision_entered(body: Node2D):
	if body is EntityWithStats:
		body.deal_damage(carried_damage, armor_penetration)
		if carried_modifiers.size() > 0:
			for modifier in carried_modifiers:
				body.add_modifier(modifier)
		GlobalSoundManager.play_sound_at_position(global_position, hit_sound, 2000, randf_range(0.8, 1.2))

	queue_free()

func _on_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent is EntityWithStats:
		parent.deal_damage(carried_damage, armor_penetration)
		GlobalSoundManager.play_sound_at_position(global_position, hit_sound, 2000, randf_range(0.8, 1.2))
	queue_free()


func _timeout():
	_trigger_lifetime_end_effect(global_position)
	queue_free()

	
func set_custom_collision_mask(new_mask: int):
	update_collision_mask.emit(new_mask)

func set_custom_layer_mask(new_mask: int):
	update_layer_mask.emit(new_mask)
