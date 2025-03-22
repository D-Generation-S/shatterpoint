class_name BuildMenuEntry extends Resource

@export var building_data: BuildModeTool
@export var name: String
@export var icon: Texture:
	set(value):
		icon = value
		if building_data.use_build_entry_icon_as_ghost:
			building_data.ghost_icon = value
