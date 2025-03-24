class_name DefaultWindow extends Window

@export var content_target_node: Control

var planned_title: String
var planned_position_and_size: Rect2
var planned_content: Array[DefaultDetailContent]

# Called when the node enters the scene tree for the first time.
func _ready():
	title = planned_title
	if planned_content.size() == 1:
		add_child(planned_content[0])
	else:
		add_multi_content(planned_content)

	popup_centered(planned_position_and_size.size)


func add_multi_content(content: Array[DefaultDetailContent]) -> void:
	var tab_container = TabContainer.new()
	tab_container.set_anchors_preset(tab_container.PRESET_FULL_RECT)
	for current_content in content:
		current_content.name = current_content.get_content_name()
		tab_container.add_child(current_content)

	
	content_target_node.add_child(tab_container)

func setup(position_and_size: Rect2, new_title: String, content: Array[DefaultDetailContent]) -> void:
	planned_title = new_title
	planned_position_and_size = position_and_size
	planned_content = content
	



func request_close():
	close_requested.emit()
	closing()

func closing():
	queue_free()