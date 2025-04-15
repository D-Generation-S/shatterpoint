class_name EntityStats extends Resource

@export_group("Base Stats")
@export var hp: float = 1
@export var armor: float = 0

@export_group("Attack Stats")
@export var fire_rate: float = 2
@export var damage: float = 1
@export var attack_range: float = 100
@export_range(0.0, 1.0, 0.0001, "suffix:percent") var armor_penetration: float = 0:
	set(value):
		armor_penetration = clampf(value, 0.0, 1.0)

@export_group("Tags")
@export var _tags: Array[Tag] = []

var max_hp: float = 1

func contains_tag(tag: Tag) -> bool:
	return _tags.any(func(current_tag): return current_tag.is_equal(tag))

func contains_any_tag(tags: Array[Tag]) -> bool:
	var return_value: bool = false
	for tag in tags:
		if contains_tag(tag):
			return_value = true
			break
	return return_value