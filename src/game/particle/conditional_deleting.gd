class_name ConditionalDeleting extends Node2D

@export var number_of_conditions: int = 1

var fulfilled_conditions = 0


func condition_fulfilled():
	fulfilled_conditions += 1
	if fulfilled_conditions >= number_of_conditions:
		queue_free()
