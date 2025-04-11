extends CanvasLayer

func _init():
    visible = true

func loading_done():
    queue_free()