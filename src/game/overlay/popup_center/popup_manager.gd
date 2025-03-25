class_name PopupManager extends CanvasLayer

var popup_areas: Array[PopupArea]

# Called when the node enters the scene tree for the first time.
func _ready():
	for children in get_children():
		if children is PopupArea:
			popup_areas.append(children)


func show_popup(popup_position: int, popup: GamePopup, replace_popup: bool = false):
	var shown: bool = false
	for popup_area in popup_areas:
		if popup_area.show_popup(popup_position, popup, replace_popup):
			shown = true
			break

	if !shown:
		printerr("Could not find popup area for position %s" % popup_position)

