extends CanvasLayer

@export var debug_menu_template: PackedScene

func _ready():
	if !OS.is_debug_build():
		queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("open_debug") and Input.is_action_pressed("open_debug"):
		var popup = debug_menu_template.instantiate() as GamePopup
		GlobalDataAccess.get_popup_manager().show_popup(PopupPosition.CENTER, popup, false)
