extends CharacterBody2D

var speed = 50

var health = 100

var dead = false
var player_in_area = false
var player
var direction
var attack_in_range = false
var can_take_damage = true

func _ready():
	dead = false
	
func _physics_process(delta):
	take_damage()
	update_healthbar()
	if !dead:
		$Player_Detection/CollisionShape2D.disabled = false
		if player_in_area and !attack_in_range:
			var start_pos = position.x
			var distance = player.position - position 
			position += distance / speed
			var end_pos = position.x
			direction = 1
			if start_pos <= end_pos:
				direction = 0
				$AnimatedSprite2D.play("walking_front")
		elif attack_in_range:
			if direction == 0:
				$AnimatedSprite2D.play("attack_front")
			elif direction == 1:
				$AnimatedSprite2D.play("attack_back")
		else:
			$AnimatedSprite2D.play("walking_back")
	if dead:
		$Player_Detection/CollisionShape2D.disabled = true
		
		

func _on_player_detection_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		Global.combat = true
		$Combat.play()
		player = body


func _on_player_detection_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
		Global.combat = false
		$Combat.stop()
	

func take_damage():
	if attack_in_range and Global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("monster health = ", health)
			if health <= 0 and !dead:
				death()
		
func death():
	dead = true
	if direction == 1:
		$AnimatedSprite2D.play("death_back")
	elif direction == 0:
		$AnimatedSprite2D.play("death_front")
	await get_tree().create_timer(1).timeout
	queue_free()
	Global.combat = false

func enemy():
	pass



func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		speed = 0
		attack_in_range = true


func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		speed = 50
		attack_in_range = false


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		speed = 0
		attack_in_range = true


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		speed = 50
		attack_in_range = false


func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_healthbar():
	var healthbar = $healthbar
	healthbar.value = health
