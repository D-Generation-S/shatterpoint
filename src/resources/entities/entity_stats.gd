class_name EntityStats extends Resource

@export_category("Base Stats")
@export var hp: float = 1
@export var armor: float = 0

@export_category("Attack Stats")
@export var fire_rate: float = 2
@export var damage: float = 1
@export var attack_range: float = 100
@export_range(0.0, 1.0, 0.0001, "suffix:percent") var armor_penetration: float = 0:
    set(value):
        armor_penetration = clampf(value, 0.0, 1.0)

var max_hp: float = 1