class_name SpecialModifierScene extends GamePopup

signal set_button_text(text: String)
signal set_tooltip_text(text: String)
signal modifier_was_selected(modifier: SpecialModifierConfiguration)

@export var possible_selections: int = 3
@export var skip_scrap: int = 25
@export var special_modifiers: Array[SpecialModifierConfiguration]
@export var card_template: PackedScene

@export var target_node: Control

func _ready():
	super()
	var loot = LootTable.new()
	set_button_text.emit(tr("SKIP_WITH_SCRAP") % skip_scrap)
	set_tooltip_text.emit(tr("SKIP_WITH_SCRAP_TOOLTIP") % skip_scrap)

	var selected_entries: Array[StatModifier] = []
	var modifier_system = GlobalDataAccess.get_modifier_system()
	for modifier in special_modifiers:
		if modifier_system.get_active_modifiers().any(func(current_modifier): return current_modifier.modifier.get_display_name() == modifier.modifier.get_display_name()):
			continue
		loot.add_entry(modifier, modifier.probability)

	for i in range(possible_selections):
		var selection = null
		var max_attempts = 10
		while selection == null and max_attempts > 0:
			selection = loot.get_selection() as SpecialModifierConfiguration
			if selection is SpecialModifierConfiguration:
				if selected_entries.any(func(entry): return entry.get_display_name() == selection.modifier.get_display_name()):
					selection = null
					max_attempts -= 1
					continue

		if selection == null:
			continue
		selected_entries.append(selection.modifier)
		var template = card_template.instantiate() as SpecialModifierSelection
		template.set_modifier(selection)
		template.modifier_selected.connect(_modifier_selected)
		template.name = selection.modifier.get_display_name()
		
		target_node.add_child(template)

func _modifier_selected(modifier: SpecialModifierConfiguration):
	modifier_was_selected.emit(modifier)
	destroy()
	

func scrap_selected():
	GlobalDataAccess.get_resource_overlay().add_scrap(skip_scrap)
	destroy()

func destroy():
	super()
	queue_free()