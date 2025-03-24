class_name TowerStatisticContent extends DefaultDetailContent


@export var _statistic_node: Control
@export var _key_value_template: PackedScene

func statistic_updated(data: BuildingBase):
	_add_statistic(data)

func _add_statistic(data: BuildingBase):
	_clear_statistic()
	_add_statistic_data("HP", data.stats.max_hp)
	_add_statistic_data("ARMOR", data.stats.armor)
	_add_statistic_data("FIRE_RATE", data.stats.fire_rate)
	_add_statistic_data("DAMAGE", data.stats.damage)
	_add_statistic_data("RANGE", data.stats.attack_range)

func _clear_statistic():
	for child in _statistic_node.get_children():
		child.queue_free()

func _add_statistic_data(key: String, value: float):
	value = snappedf(value, 0.01)
	var template = _key_value_template.instantiate() as KeyValueData
	template.set_key_value_pair(key, str(value))
	_statistic_node.add_child(template)
