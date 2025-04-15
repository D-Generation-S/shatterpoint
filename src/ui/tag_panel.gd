extends PanelContainer

@export var border_radius: int = 200
@export var border_thickness: int = 3

func set_color(color: Color):
	var stylebox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	stylebox.bg_color = color

	stylebox.corner_radius_bottom_left = border_radius
	stylebox.corner_radius_bottom_right = border_radius
	stylebox.corner_radius_top_left = border_radius
	stylebox.corner_radius_top_right = border_radius

	stylebox.border_width_bottom = border_thickness
	stylebox.border_width_left = border_thickness
	stylebox.border_width_top = border_thickness
	stylebox.border_width_right = border_thickness

	stylebox.border_blend = true
	add_theme_stylebox_override("panel", stylebox)
