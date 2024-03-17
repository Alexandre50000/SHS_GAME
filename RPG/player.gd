extends CharacterBody2D


@export var SPEED = 100 # How fast the player will move (pixels/sec).
var screen_size 
var direction = 0
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var attack_ip = false

func _physics_process(delta):
	move_and_slide()
	enemy_attack()
	attack()
	update_health()
	if health <= 0:
		player_alive = false
		health = 0
		print("player is dead")
		self.queue_free()
		
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right") and !attack_ip:
		velocity.x = 1
		direction = 0
		$AnimatedSprite2D.play("right_walk")
	elif Input.is_action_pressed("move_left") and !attack_ip:
		velocity.x = -1
		direction = 1
		$AnimatedSprite2D.play("left_walk")
	elif Input.is_action_pressed("move_down") and !attack_ip:
		velocity.y = 1
		direction = 2
		$AnimatedSprite2D.play("front_walk")
	elif Input.is_action_pressed("move_up") and !attack_ip:
		velocity.y = -1
		direction = 3
		$AnimatedSprite2D.play("back_walk")
	else:
		if direction == 0  and !attack_ip:
			$AnimatedSprite2D.play("right_idle")
		elif direction == 1 and !attack_ip: 
			$AnimatedSprite2D.play("left_idle")
		elif direction == 2 and !attack_ip:
			$AnimatedSprite2D.play("front_idle")
		elif direction == 3 and !attack_ip:
			$AnimatedSprite2D.play("back_idle")

	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	position += velocity * delta
	

func player():
	pass


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false
		
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true and !attack_ip:
		health = health - 10
		enemy_attack_cooldown = false
		print(health)
		$attack_cooldown.start()

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		attack_ip = true
		velocity.x = 0
		velocity.y = 0
		if direction == 0:
			$AnimatedSprite2D.play("right_attack")
			$deal_attack_timer.start()
		elif direction == 1:
			$AnimatedSprite2D.play("left_attack")
			$deal_attack_timer.start()
		elif direction == 2:
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		elif direction == 3:
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false


func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100 and !attack_ip:
		healthbar.visible = false
	else:
		healthbar.visible = true
	

func _on_regen_timer_timeout():
	if health < 100 and !attack_ip:
		health = health + 20
		if health > 100:
			health = 100
	if health == 0:
		health = 0
