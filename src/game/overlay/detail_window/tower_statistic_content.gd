class_name TowerStatisticContent extends DefaultDetailContent


@export var _statistic_node: Control
@export var _key_value_template: PackedScene

@export_group("Health Points")
@export var _hp_text: TranslationResource
@export var _hp_description: TranslationResource
@export var _hp_icon: Texture

@export_group("Armor")
@export var _armor_text: TranslationResource
@export var _armor_description: TranslationResource
@export var _armor_icon: Texture

@export_group("Penetration")
@export var _armor_penetration_text: TranslationResource
@export var _armor_penetration_description: TranslationResource
@export var _armor_penetration_icon: Texture

@export_group("Fire Rate")
@export var _fire_rate_text: TranslationResource
@export var _fire_rate_description: TranslationResource
@export var _fire_rate_icon: Texture

@export_group("Damage")
@export var _damage_rate_text: TranslationResource
@export var _damage_rate_description: TranslationResource
@export var _damage_rate_icon: Texture

@export_group("Range")
@export var _range_rate_text: TranslationResource
@export var _range_description: TranslationResource
@export var _range_rate_icon: Texture

func statistic_updated(data: BuildingBase):
	_add_statistic(data)

func _add_statistic(data: BuildingBase):
	_clear_statistic()
	_add_statistic_data(_hp_text.key, data.stats.max_hp, _hp_description.key, _hp_icon)
	_add_statistic_data(_armor_text.key, data.stats.armor, _armor_description.key, _armor_icon)
	_add_statistic_data(_armor_penetration_text.key, data.stats.armor_penetration * 100, _armor_penetration_description.key, _armor_penetration_icon, "%")
	_add_statistic_data(_fire_rate_text.key, data.stats.fire_rate, _fire_rate_description.key, _fire_rate_icon)
	_add_statistic_data(_damage_rate_text.key, data.stats.damage, _damage_rate_description.key, _damage_rate_icon)
	_add_statistic_data(_range_rate_text.key, data.stats.attack_range, _range_description.key, _range_rate_icon)

func _clear_statistic():
	for child in _statistic_node.get_children():
		child.queue_free()

func _add_statistic_data(key: String, value: float, description: String = "", icon: Texture = null, value_suffix: String = ""):
	value = snappedf(value, 0.01)
	var template = _key_value_template.instantiate() as KeyValueData
	template.set_icon(icon)
	template.set_key_value_pair(key, "%s %s" % [str(value), value_suffix], description)
	_statistic_node.add_child(template)
