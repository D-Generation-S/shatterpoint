class_name SpecialModifierSelection extends PanelContainer

signal name_changed(text: String)
signal description_changed(text: String)
signal icon_changed(texture: Texture2D)
signal modifier_selected(modifier: SpecialModifierConfiguration)
#signal applies_to_changed(text: String)

@export var tag_template: PackedScene
@export var tag_target: Node

var _stored_modifier: SpecialModifierConfiguration

func set_modifier(modifier: SpecialModifierConfiguration):
	_stored_modifier = modifier
	name_changed.emit(_stored_modifier.modifier.get_display_name())
	description_changed.emit(tr(_stored_modifier.modifier.get_display_description()) % _stored_modifier.modifier.get_value())
	icon_changed.emit(_stored_modifier.modifier.get_display_icon())
	for tag in _create_tag_scenes(modifier):
		tag_target.add_child(tag)
	#applies_to_changed.emit(_create_tag_scenes(modifier))

func _create_tag_scenes(modifier: SpecialModifierConfiguration) -> Array[TagTemplate]:
	
	var return_tags: Array[TagTemplate]
	for tag in modifier.get_tags():
		var template = tag_template.instantiate() as TagTemplate
		if template == null:
			return []
		template.setup(tag)
		return_tags.append(template)

	return return_tags
	#var applies_to: Array[String] = []
	#if modifier.scope & (1 << ModifierSystem.ModifierScope.TOWER):
	#	applies_to.append(create_applies_to_line("APPLIES_TO_TOWERS", tr("APPLIES_TO_TOWERS")))
	#if modifier.scope & (1 << ModifierSystem.ModifierScope.GENERATOR):
	#	applies_to.append(create_applies_to_line("APPLIES_TO_GENERATORS", tr("APPLIES_TO_GENERATORS")))
	#if modifier.scope & (1 << ModifierSystem.ModifierScope.SCRAP_STORAGE):
		#applies_to.append(create_applies_to_line("APPLIES_TO_SCRAP_STORAGES", tr("APPLIES_TO_SCRAP_STORAGES")))
	#if modifier.scope & (1 << ModifierSystem.ModifierScope.UNIT_SPAWNER):
	#	applies_to.append(create_applies_to_line("APPLIES_TO_UNIT_SPAWNERS", tr("APPLIES_TO_UNIT_SPAWNERS")))
	#if modifier.scope & (1 << ModifierSystem.ModifierScope.UNIT):
	#	applies_to.append(create_applies_to_line("APPLIES_TO_UNITS", tr("APPLIES_TO_UNITS")))
	#if modifier.scope & (1 << ModifierSystem.ModifierScope.GLOBAL):
	#	applies_to.append(create_applies_to_line("APPLIES_TO_GLOBAL", tr("APPLIES_TO_GLOBAL")))

	#applies_to.sort()
	#var list_number = ""
	#for applicant in applies_to:
		#list_number += "%s\n" % applicant

	#return "[ul]%s[/ul]" % list_number

func create_applies_to_line(text_key: String, text_translation: String) -> String:
	if GlobalExplainTooltip.has_information_for_tooltip(text_key):
		return "[url=%s]%s[/url]" % [text_key, text_translation]
	return text_translation

func button_was_pressed():
	modifier_selected.emit(_stored_modifier)
