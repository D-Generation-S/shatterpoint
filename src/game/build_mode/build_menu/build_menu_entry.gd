class_name BuildMenuEntry extends Resource

@export var building_data: BuildModeTool
@export var icon: Texture:
	set(value):
		icon = value
		if building_data.use_build_entry_icon_as_ghost:
			building_data.ghost_icon = value

func get_building_name() -> String:
	return building_data.get_tool_name()

func get_building_description() -> String:
	return "%s_DESCRIPTION" % get_building_name()