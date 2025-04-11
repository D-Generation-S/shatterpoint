class_name LootTable extends Resource

var entries: Dictionary
var table: Array[int]
var current_number: int = 0

func add_entry(entry: Object, times: int):
    entries[current_number] = entry
    for i in range(times):
        table.append(current_number)
    current_number += 1

func get_selection() -> Object:
    table.shuffle()
    var index = table.pick_random()
    return entries[index]