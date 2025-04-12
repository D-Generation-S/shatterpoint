class_name TickStatModifier extends StatModifier

## How often will this effect be triggered in ticks
@export var max_ticks: int = 1000000000

var _current_tick: int = 0

## Should not be overwritten, please use the _apply_tick_changed method instead.
func tick_stat_change(real_stats: EntityStats):
    if !is_valid():
        return
    if _current_tick >= max_ticks:
        valid = false

    _current_tick += 1
    _apply_tick_changed(real_stats)
    
func _apply_tick_changed(_real_stats: EntityStats):
    pass

