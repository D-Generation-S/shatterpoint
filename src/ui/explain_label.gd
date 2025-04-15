class_name ExplainLabel extends Label

var _tooltip_key: String

func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_PASS

func set_tooltip_key(key: String):
	if key == null:
		tooltip_text = ""
		return		
	tooltip_text = "dummy"
	_tooltip_key = key

func _make_custom_tooltip(_for_text):
	GlobalExplainTooltip.show_tooltip(global_position, _tooltip_key)

	var dummy = Label.new()
	dummy.tooltip_text = ""
	dummy.visible = false
	dummy.queue_free()
	return dummy