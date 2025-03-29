extends Node

var base_folder = "user://"
var screenshot_path = "screenshots/"

func _ready():
	if OS.has_feature("web"):
		Console.print("Screenshot system is not available on web platform.")
		queue_free()

	var dir = DirAccess.open("user://")
	dir.make_dir(screenshot_path)
	Console.register_custom_command("take_screenshot", take_screenshot, [], "Take a screenshot of the current viewport.")
	
func _exit_tree():
	Console.remove_command("take_screenshot")

func _get_base_path():
	return base_folder + screenshot_path

func take_screenshot():
	if OS.has_feature("web"):
		Console.print("Screenshot system is not available on web platform.")
	
	Console.print("Taking screenshot...")
	var data = get_viewport().get_texture().get_image()
	var date = Time.get_datetime_dict_from_system()
	var prefix = "%s%s%s_%s%s%s" % [date.year, date.month, date.day, date.hour, date.minute, date.second]
	var file_path = "%s%s_screenshot.png" % [_get_base_path(), prefix]
	data.save_png(file_path)
	var saved_message = "Screenshot saved to %s" % file_path
	Console.print(saved_message)
	var message_area = GlobalDataAccess.get_message_area()
	if message_area != null:
		message_area.add_simple_message(MessagePosition.BOTTOM_RIGHT, saved_message, 5)

func _unhandled_input(event):
	if event.is_action_pressed("take_screenshot") and Input.is_action_pressed("take_screenshot"):
		take_screenshot()
