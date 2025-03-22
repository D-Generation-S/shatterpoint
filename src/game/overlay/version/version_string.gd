extends Label

@export var version_translation: String

# Called when the node enters the scene tree for the first time.
func _ready():
	text = tr(version_translation) 
	text += ": "
	text += ProjectSettings.get_setting("application/config/version")
