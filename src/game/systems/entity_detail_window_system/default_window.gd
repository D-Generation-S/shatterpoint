class_name DefaultWindow extends PanelContainer

signal close_requested()
signal title_changed(text: String)

@export var content_target_node: Control

var planned_title: String
var planned_position_and_size: Rect2
var planned_content: Array[DefaultDetailContent]

# Called when the node enters the scene tree for the first time.
func _ready():
	title_changed.emit(planned_title)
	if planned_content.size() == 1:
		content_target_node.add_child(planned_content[0])
	else:
		add_multi_content(planned_content)

	update_position()


func add_multi_content(content: Array[DefaultDetailContent]) -> void:
	var tab_container = TabContainer.new()
	tab_container.set_anchors_preset(tab_container.PRESET_FULL_RECT)
	for current_content in content:
		current_content.name = current_content.get_content_name()
		tab_container.add_child(current_content)

	
	content_target_node.add_child(tab_container)

func setup(position_and_size: Rect2, new_title: String, content: Array[DefaultDetailContent]) -> void:
	
	planned_position_and_size = position_and_size
	planned_title = new_title
	planned_content = content

	custom_minimum_size = planned_position_and_size.size

func update_position():
	var viewport_size = get_viewport_rect().size
	position = Vector2(viewport_size.x / 2, viewport_size.y / 2)
	position -= planned_position_and_size.size / 2

func request_close():
	close_requested.emit()
	closing()

func closing():
	queue_free()
