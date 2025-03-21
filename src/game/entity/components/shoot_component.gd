class_name ShootComponent extends EntityComponent

var projectile_scene: PackedScene

func fire(current_target: Node2D, damage: float, penetration: float):
	var projectile = projectile_scene.instantiate() as Projectile
	projectile.setup(self.global_position, current_target, damage, penetration, self)
	add_child(projectile)
	projectile.fire()

func set_projectile(projectile_template: PackedScene):
	projectile_scene = projectile_template
