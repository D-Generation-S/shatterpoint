extends Node

signal camera_target_request(position: Vector2)

func handle_interaction(data: Dictionary):
	match data.get_or_add("type", "UNKNOWN"):
		"move_camera":
			var additional = data.get_or_add("additional", {})
			if additional == null:
				printerr("move_camera: no additional data")
				return
			var x = additional.get_or_add("x", 0)
			var y = additional.get_or_add("y", 0)
			camera_target_request.emit(Vector2(x, y))
		_:
			printerr("Unknown interaction of type: %s" % data.type)