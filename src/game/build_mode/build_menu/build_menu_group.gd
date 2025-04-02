class_name BuildMenuGroup extends Resource

@export var display_name: String
@export var icon: Texture
@export var entries: Array[BuildMenuEntry]

func get_display_name() -> String:
    return display_name

func get_display_description() -> String:
    return "%s_DESCRIPTION" % get_display_name()