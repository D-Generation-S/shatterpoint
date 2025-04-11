
class_name PopupArea extends Control

@export_enum("Top Left:0",
			 "Top Center:1", 
			 "Top Right:2", 
			 "Center Left:3", 
			 "Center:4", 
			 "Center Right:5",
			 "Bottom Left:6",
			 "Bottom Center:7",
			 "Bottom Right:8",
			 "Full Screen: 9") var _popup_position: int

var popup_queue: Array[GamePopup]
var currently_active_popup: GamePopup = null

func _init():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_popup(popup_position: int, popup: GamePopup, replace_popup: bool = false) -> bool:
	if popup_position != _popup_position:
		return false
	popup_queue.append(popup)
	if replace_popup and currently_active_popup != null:
		var oldest_popup = popup_queue.pop_back()
		currently_active_popup.store_popup()
		remove_child(currently_active_popup)
		popup_queue.insert(0, currently_active_popup)
		popup_queue.insert(0, oldest_popup)
		currently_active_popup = null

	if currently_active_popup == null:
		show_next_popup()
	return true

func show_next_popup():
	if popup_queue.size() == 0:
		return
	currently_active_popup = popup_queue.pop_front()
	currently_active_popup.closing.connect(popup_closing)
	if currently_active_popup.should_pause_game():
		get_tree().paused = true
	currently_active_popup.unstore_popup()
	add_child(currently_active_popup)


func popup_closing(_popup: GamePopup):
	get_tree().paused = false
	show_next_popup()
