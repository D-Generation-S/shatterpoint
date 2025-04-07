class_name SpecialModifierSelection extends PanelContainer

signal name_changed(text: String)
signal description_changed(text: String)
signal icon_changed(texture: Texture2D)
signal modifier_selected(modifier: SpecialModifierConfiguration)

var _stored_modifier: SpecialModifierConfiguration

func set_modifier(modifier: SpecialModifierConfiguration):
    _stored_modifier = modifier
    name_changed.emit(_stored_modifier.modifier.get_display_name())
    var description = tr(_stored_modifier.modifier.get_display_description()) % _stored_modifier.modifier.get_value()
    description_changed.emit(tr(_stored_modifier.modifier.get_display_description()) % _stored_modifier.modifier.get_value())
    icon_changed.emit(_stored_modifier.modifier.get_display_icon())

func button_was_pressed():
    modifier_selected.emit(_stored_modifier)