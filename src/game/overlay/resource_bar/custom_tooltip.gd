class_name CustomTooltip extends Control

@export var tooltip_header: Label
@export var tooltip_icon: TextureRect
@export var tooltip_content: RichTextLabel

var text: String
var description: String
var icon: Texture

func _ready():
	tooltip_header.text = text
	tooltip_content.text = description
	tooltip_icon.texture = icon
	if icon == null:
		tooltip_icon.visible = false

func setup(tooltip: String, tooltip_description: String = "", new_tooltip_icon: Texture = null):
	text = tooltip
	description = tooltip_description
	icon = new_tooltip_icon
