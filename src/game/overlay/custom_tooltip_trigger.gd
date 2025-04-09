class_name CustomTooltipTrigger extends Control

@export var tooltip_template: PackedScene = preload("res://scenes/game/overlay/tooltips/explain_tooltip_template.tscn")
@export var tooltip_key: String
@export var tooltip_data: TooltipData
@export var tooltip_offset: Vector2 = Vector2(0, 0)

func _init():
	tooltip_text = "trigger"

func _make_custom_tooltip(_for_text) -> Object:
	var tooltip_position = get_viewport().get_mouse_position() - tooltip_offset
	if tooltip_data != null:
		GlobalExplainTooltip.show_tooltip_for_data(tooltip_position, tooltip_data)
	else:
		GlobalExplainTooltip.show_tooltip(tooltip_position, tooltip_key)

	var dummy = Label.new()
	dummy.tooltip_text = ""
	dummy.visible = false
	dummy.queue_free()
	return dummy