class_name EnemyTargetArea extends Area2D

signal town_was_reached(body: Node2D)

func _ready():
	body_entered.connect(_body_entered)

func _body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		town_was_reached.emit(body)
