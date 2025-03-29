class_name EntityAnimation extends Resource

@warning_ignore("unused_variable")
var tween: Tween

func animate_visuals(_visuals: Sprite2D):
	pass

func kill_animation():
	if tween == null:
		return
	tween.kill()