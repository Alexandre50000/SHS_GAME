extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.combat == true:
		$Env.stream_paused = true
	else:
		$Env.stream_paused = false
	pass
