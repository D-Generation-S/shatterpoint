extends Button

@export var line_edit: LineEdit

func _pressed():
	var overlay= GlobalDataAccess.get_resource_overlay()
	var data = int(line_edit.text)
	overlay.add_power(data)