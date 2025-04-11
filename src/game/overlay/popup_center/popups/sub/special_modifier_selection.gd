class_name SpecialModifierSelection extends PanelContainer

signal name_changed(text: String)
signal description_changed(text: String)
signal icon_changed(texture: Texture2D)
signal modifier_selected(modifier: SpecialModifierConfiguration)
signal applies_to_changed(text: String)

var _stored_modifier: SpecialModifierConfiguration

func set_modifier(modifier: SpecialModifierConfiguration):
	_stored_modifier = modifier
	name_changed.emit(_stored_modifier.modifier.get_display_name())
	description_changed.emit(tr(_stored_modifier.modifier.get_display_description()) % _stored_modifier.modifier.get_value())
	icon_changed.emit(_stored_modifier.modifier.get_display_icon())
	applies_to_changed.emit(create_applies_to_bb_code(modifier))

func create_applies_to_bb_code(modifier: SpecialModifierConfiguration) -> String:
	var applies_to: Array[String] = []
	if modifier.scope & (1 << ModifierSystem.ModifierScope.TOWER):
		applies_to.append(tr("APPLIES_TO_TOWERS"))
	if modifier.scope & (1 << ModifierSystem.ModifierScope.GENERATOR):
		applies_to.append(tr("APPLIES_TO_GENERATORS"))
	if modifier.scope & (1 << ModifierSystem.ModifierScope.SCRAP_STORAGE):
		applies_to.append(tr("APPLIES_TO_SCRAP_STORAGES"))
	if modifier.scope & (1 << ModifierSystem.ModifierScope.UNIT_SPAWNER):
		applies_to.append(tr("APPLIES_TO_UNIT_SPAWNERS"))
	if modifier.scope & (1 << ModifierSystem.ModifierScope.UNIT):
		applies_to.append(tr("APPLIES_TO_UNITS"))

	applies_to.sort()
	var list_number = ""
	for applicant in applies_to:
		list_number += "%s\n" % applicant

	return "[ul]%s[/ul]" % list_number

func button_was_pressed():
	modifier_selected.emit(_stored_modifier)