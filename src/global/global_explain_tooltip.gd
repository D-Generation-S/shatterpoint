extends Node

var base_folder = "res://assets/resources/tooltips/"
@onready var default_tooltip = preload("res://scenes/game/overlay/tooltips/explain_tooltip_template.tscn")

var _tooltip_data := {}
var root: CanvasLayer

var current_open_tooltips: Array[String] = []

func _init():
	root = CanvasLayer.new()
	root.layer = RenderingServer.CANVAS_ITEM_Z_MAX 
	
	add_child(root)

	for file_name in DirAccess.get_files_at(base_folder):
		# https://forum.godotengine.org/t/issue-with-reading-tres-files-after-exporting-project/75731/4
		if file_name.ends_with(".remap"):
			file_name = file_name.trim_suffix(".remap")
		var real_file = "%s%s" % [base_folder, file_name]
		var data = load(real_file) as TooltipData
		if data == null:
			continue
		_tooltip_data[data.key] = data

func show_tooltip(target_position: Vector2, term_key: String):
	var data = _tooltip_data.get_or_add(term_key, null) as TooltipData
	if data == null:
		return
	show_tooltip_for_data(target_position, data)

func show_tooltip_for_data(target_position: Vector2, tooltip: TooltipData):
	var template = default_tooltip.duplicate().instantiate() as ExplainTooltip
	template.setup(tooltip)
	show_custom_tooltip(target_position, template)

func show_custom_tooltip(target_position: Vector2, tooltip: ExplainTooltip):
	if current_open_tooltips.any(func(key): return key == tooltip.get_key()):
		return

	var viewport_size: Rect2 = get_viewport().get_visible_rect()
	target_position.x = clampi(int(target_position.x), 0, int(viewport_size.end.x - tooltip.size.x))
	target_position.y = clampi(int(target_position.y), 0, int(viewport_size.end.y - tooltip.size.y))
	tooltip.position = target_position
	
	tooltip.closing_now.connect(_tooltip_closed)
	root.add_child(tooltip)
	
	current_open_tooltips.append(tooltip.get_key())

func has_information_for_tooltip(tooltip: String) -> bool:
	return _tooltip_data.has(tooltip) and _tooltip_data[tooltip] != null

func _tooltip_closed(key: String):
	current_open_tooltips.erase(key)