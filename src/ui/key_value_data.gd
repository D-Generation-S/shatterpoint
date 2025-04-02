class_name KeyValueData extends MarginContainer

@onready var icon_box: TextureRect = $"%Icon"
@onready var key_label: Label = $"%Key"
@onready var value_label: Label = $"%Value"

var key_to_set: String
var icon_to_set: Texture
var value_to_set: String
var tooltip_to_set: String



func set_icon(new_icon: Texture):
	icon_to_set = new_icon
	_update_data()

func set_key_value_pair(key: String, value:String, tooltip: String = ""):
	key_to_set = key
	value_to_set = value
	tooltip_to_set = tooltip
	_update_data()
	

func _update_data():
	if !is_node_ready():
		return
	icon_box.texture = icon_to_set
	if icon_box.texture == null:
		icon_box.visible = false
	key_label.text = key_to_set
	key_label.tooltip_text = tooltip_to_set
	icon_box.tooltip_text = tooltip_to_set
	value_label.text = value_to_set

	


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_data()