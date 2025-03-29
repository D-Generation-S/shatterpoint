class_name TowerStatisticContent extends DefaultDetailContent


@export var _statistic_node: Control
@export var _key_value_template: PackedScene

@export_group("Health Points")
@export var _hp_text: String = "HP"
@export var _hp_icon: Texture

@export_group("Armor")
@export var _armor_text: String = "ARMOR"
@export var _armor_icon: Texture

@export_group("Penetration")
@export var _armor_penetration_text: String = "ARMOR_PENETRATION"
@export var _armor_penetration_icon: Texture

@export_group("Fire Rate")
@export var _fire_rate_text: String = "FIRE_RATE"
@export var _fire_rate_icon: Texture

@export_group("Damage")
@export var _damage_rate_text: String = "DAMAGE"
@export var _damage_rate_icon: Texture

@export_group("Range")
@export var _range_rate_text: String = "RANGE"
@export var _range_rate_icon: Texture

func statistic_updated(data: BuildingBase):
	_add_statistic(data)

func _add_statistic(data: BuildingBase):
	_clear_statistic()
	_add_statistic_data(_hp_text, data.stats.max_hp, _hp_icon)
	_add_statistic_data(_armor_text, data.stats.armor, _armor_icon)
	_add_statistic_data(_armor_penetration_text, data.stats.armor_penetration * 100, _armor_penetration_icon, "%")
	_add_statistic_data(_fire_rate_text, data.stats.fire_rate, _fire_rate_icon)
	_add_statistic_data(_damage_rate_text, data.stats.damage, _damage_rate_icon)
	_add_statistic_data(_range_rate_text, data.stats.attack_range, _range_rate_icon)

func _clear_statistic():
	for child in _statistic_node.get_children():
		child.queue_free()

func _add_statistic_data(key: String, value: float, icon: Texture = null, value_suffix: String = ""):
	value = snappedf(value, 0.01)
	var template = _key_value_template.instantiate() as KeyValueData
	template.set_icon(icon)
	template.set_key_value_pair(key, "%s %s" % [str(value), value_suffix])
	_statistic_node.add_child(template)
