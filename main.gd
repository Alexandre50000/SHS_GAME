extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_medusa_body_entered(body):
	if body == $CharacterBody2D:
		$Medusa/AnimatedSprite2D.play("Attack_front")


func _on_medusa_body_exited(body):
	if body == $CharacterBody2D:
		$Medusa/AnimatedSprite2D.play("Idle_front")
