extends Area2D

func _ready():
	body_entered.connect(_body_entered)

func _body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		if body is Enemy:
			body.town_reached()
