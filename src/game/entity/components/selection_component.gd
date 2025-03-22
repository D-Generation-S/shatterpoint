class_name SingleSelectionComponent extends EntityComponent

signal selection_changed(selected: bool)

var selected: bool = false
@onready var interaction_shape: CollisionShape2D = $"%InteractionShape"

func interacting():
	selection_changed.emit(true)
	selected = true
	pass

func interaction_canceled():
	selection_changed.emit(false)
	selected = false

func change_interaction_radius(radius: float):
	var shape = interaction_shape.shape
	if shape is CircleShape2D:
		shape.radius = radius