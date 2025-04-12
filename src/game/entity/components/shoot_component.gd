class_name ShootComponent extends EntityComponent

signal add_projectile(bullet: Projectile)

@export var update_collision_mask: bool = false
@export_flags_2d_physics var projectile_collision_mask: int = 2

var projectile_scene: PackedScene
var projectile_modifiers: Array[StatModifier]

func fire(current_target: Node2D, damage: float, penetration: float):
	var projectile = projectile_scene.instantiate() as Projectile
	if update_collision_mask:
		projectile.set_custom_collision_mask(projectile_collision_mask)
	projectile.setup(self.global_position, current_target, damage, penetration, projectile_modifiers)
	add_projectile.emit(projectile)
	projectile.fire()

func modifier_added(modifier: StatModifier):
	if !modifier.projectile_modifier:
		return
	projectile_modifiers.append(modifier)

func modifier_removed(modifier: StatModifier):	
	if !modifier.projectile_modifier:
		return
	projectile_modifiers.erase(modifier)

func set_projectile(projectile_template: PackedScene):
	projectile_scene = projectile_template
