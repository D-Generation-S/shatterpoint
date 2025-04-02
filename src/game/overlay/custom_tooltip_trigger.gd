class_name CustomTooltipTrigger extends Control

@export var tooltip_template: PackedScene = preload("res://scenes/game/overlay/tooltips/resource_bar_tooltip_template.tscn")
@export var tooltip_icon: Texture = null
@export var description: String

func _make_custom_tooltip(for_text) -> Object:
	var template = tooltip_template.instantiate() as CustomTooltip
	template.setup(tr(for_text), tr(description), tooltip_icon)
	return template