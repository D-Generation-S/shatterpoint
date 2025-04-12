class_name SpecialModifierScene extends GamePopup

signal set_button_text(text: String)
signal set_tooltip_text(text: String)
signal modifier_was_selected(modifier: SpecialModifierConfiguration)
signal set_reroll_button_text(text: String)
signal update_reroll_price(price: int)
signal update_global_scrap_count(number: int)
signal update_max_scrap_count(number: int)

@export var possible_selections: int = 3
@export var skip_scrap: int = 25
@export var initial_reroll_cost: int = 5
@export var card_template: PackedScene
@export var target_node: Control

var current_reroll_cost: int = 0

var special_modifiers: Array[SpecialModifierConfiguration]

func set_possible_modifiers(modifiers: Array[SpecialModifierConfiguration]):
	special_modifiers = modifiers

# Rework logic to copy the possible modifiers and remove all which are already taken or not accessible right now.
# Choose one, remove it from the list and continue until selections reached.
func _ready():
	super()
	current_reroll_cost = initial_reroll_cost

	set_button_text.emit(tr("SKIP_WITH_SCRAP") % skip_scrap)
	set_tooltip_text.emit(tr("SKIP_WITH_SCRAP_TOOLTIP") % skip_scrap)
	update_reroll_price.emit(current_reroll_cost)
	set_reroll_button_text.emit(tr("REROLL_BUTTON") % current_reroll_cost)
	update_max_scrap_count.emit(GlobalDataAccess.get_resource_overlay().get_max_scrap())
	update_global_scrap()

	_generate_modifier_selection()

func update_global_scrap():
	var scrap: int = GlobalDataAccess.get_resource_overlay().get_scrap()
	update_global_scrap_count.emit(scrap)

func _generate_modifier_selection():
	var loot = LootTable.new()
	var selected_entries: Array[StatModifier] = []
	for modifier in special_modifiers:
		loot.add_entry(modifier, modifier.probability)

	for i in possible_selections:
		var selection = null
		var max_attempts = 10
		while selection == null and max_attempts > 0:
			selection = loot.get_selection() as SpecialModifierConfiguration
			if selection is SpecialModifierConfiguration:
				if selected_entries.any(func(entry): return entry.resource_path == selection.modifier.resource_path):
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

func _reroll_shop():
	for child in target_node.get_children():
		child.queue_free()
	_generate_modifier_selection()
	GlobalDataAccess.get_resource_overlay().add_scrap(-current_reroll_cost)
	update_global_scrap()

	current_reroll_cost *= 2;
	update_reroll_price.emit(current_reroll_cost)
	set_reroll_button_text.emit(tr("REROLL_BUTTON") % current_reroll_cost)
	pass	

func scrap_selected():
	GlobalDataAccess.get_resource_overlay().add_scrap(skip_scrap)
	destroy()

func destroy():
	super()
	queue_free()