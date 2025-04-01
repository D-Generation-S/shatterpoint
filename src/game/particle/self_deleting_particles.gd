extends GPUParticles2D


func _ready():
	one_shot = true
	restart()
	finished.connect(_animation_played)

func _animation_played():
	queue_free()
