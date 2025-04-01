extends Label

@export var version_translation: TranslationResource

# Called when the node enters the scene tree for the first time.
func _ready():
	text = tr(version_translation.key) 
	text += ": "
	text += ProjectSettings.get_setting("application/config/version")

	Console.register_custom_command("toggle_version", _toggle_version, ["(bool) 1/0"], "Toggle on or off the version string")

func _exit_tree():
	pass

func _toggle_version(on: String) -> String:
	on = on.trim_prefix(" ")
	on = on.trim_suffix(" ")
	var new_state = false
	if on == "1":
		new_state = true

	visible = bool(new_state)
	return "Version string is now %s" % str(visible)
