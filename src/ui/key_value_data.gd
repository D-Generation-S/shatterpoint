class_name KeyValueData extends MarginContainer


@onready var icon_box: TextureRect = $"%Icon"
@onready var key_label: ExplainRichTextLabel = $"%Key"
@onready var value_label: Label = $"%Value"

var key_to_set: String
var icon_to_set: Texture
var value_to_set: String
var tooltip_to_set: String

func _ready():
	key_label.bbcode_enabled = true
	key_label.fit_content = true
	key_label.inside_of_popup = true
	_update_data()

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
	var new_text = tr(key_to_set)
	if GlobalExplainTooltip.has_information_for_tooltip(key_to_set):
		new_text = "[url=%s]%s[/url]" % [key_to_set, tr(key_to_set)]
	key_label.clear()
	key_label.append_text(new_text)
	key_label.tooltip_text = tooltip_to_set
	icon_box.tooltip_text = tooltip_to_set
	value_label.text = value_to_set
