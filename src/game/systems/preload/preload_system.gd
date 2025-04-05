extends Node

signal preload_completed()

@export var scenes_to_preload: Array[PackedScene]
@export_range(0.1, 2, 0.001) var keep_preload_for_seconds: float = 2

var timer: Timer

func _ready():
    timer = Timer.new()
    timer.autostart = false
    timer.one_shot = true
    timer.wait_time = keep_preload_for_seconds
    timer.timeout.connect(_timeout)

    add_child(timer)
    spawn_preload()

    timer.start()

func spawn_preload():
    for scene in scenes_to_preload:
        var template = scene.instantiate() as Node2D
        template.global_position = Vector2.ZERO
        add_child(template)

func _timeout():
    queue_free()
    GlobalDataAccess.get_sticker_system().clear_stickers()
    preload_completed.emit()


