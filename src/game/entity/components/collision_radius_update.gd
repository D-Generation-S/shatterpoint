extends CollisionShape2D

@export var collision_radius: int = 8

func _ready():
    if shape is CircleShape2D:
        shape.radius = collision_radius