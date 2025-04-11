class_name EntityDetailWindowSystem extends CanvasLayer

@export var default_window_template: PackedScene
@export var popup_window_group: String = "popup_window"

func _ready():
	if default_window_template == null:
		printerr("No default window template set")

func request_window(position: Vector2, size: Vector2, title: String, content: Array[DefaultDetailContent], close_others: bool = false):
	if close_others:
		close_all_windows()
	var template = default_window_template.instantiate() as DefaultWindow
	if template == null:
		printerr("template was not using default window")
		return

	template.setup(Rect2(position, size), title, content)
	template.add_to_group(popup_window_group)
	add_child(template)

func close_all_windows():
	for window in get_children().filter(func(child): return child.is_in_group(popup_window_group)):
		if window is DefaultWindow:
			window.request_close()