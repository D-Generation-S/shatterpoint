extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	one_shot = true
	finished.connect(_animation_played)

func _animation_played():
	queue_free()
