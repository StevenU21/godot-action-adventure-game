extends "res://scripts/character.gd"

const SPEED = 100
var CURRENT_DIR = "down"
var ENEMY_IN_ATTACK_RANGE = false
var ENEMY_ATTACK_COOLDOWN = true
var ATTACK_IP = false

func _ready():
	add_to_group("player")
	$AnimatedSprite2D.play("front_idle")
	$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	update_health_bar()

func _physics_process(_delta: float):
	if not IS_ALIVE:
		return
		
	player_movement(_delta)
	enemy_attack()
	attack()
	update_health_bar()

func die():
	IS_ALIVE = false
	set_physics_process(false)
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("death")

func _on_animated_sprite_2d_animation_finished(anim_name = "") -> void:
	if $AnimatedSprite2D.animation == "death" or anim_name == "death":
		get_tree().reload_current_scene()

func player_movement(_delta):
	if ATTACK_IP:
		velocity = Vector2.ZERO
		player_animation(0)
		move_and_slide()
		return

	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * SPEED
		if abs(input_vector.x) > abs(input_vector.y):
			CURRENT_DIR = "right" if input_vector.x > 0 else "left"
		else:
			CURRENT_DIR = "down" if input_vector.y > 0 else "up"
		player_animation(1)
	else:
		velocity = Vector2.ZERO
		player_animation(0)

	move_and_slide()

func player_animation(movement):
	var anim = $AnimatedSprite2D
	var dir = CURRENT_DIR

	anim.flip_h = (dir == "left")
	
	if ATTACK_IP:
		return 

	match dir:
		"right", "left":
			anim.play("side_walk" if movement == 1 else "side_idle")
		"down":
			anim.play("front_walk" if movement == 1 else "front_idle")
		"up":
			anim.play("back_walk" if movement == 1 else "back_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		ENEMY_IN_ATTACK_RANGE = true
	
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		ENEMY_IN_ATTACK_RANGE = false
		
func enemy_attack():
	if ENEMY_IN_ATTACK_RANGE and ENEMY_ATTACK_COOLDOWN:
		take_damage(20)
		ENEMY_ATTACK_COOLDOWN = false
		$attack_cooldown.start()
		print(HEALTH)
 
func _on_attack_cooldown_timeout() -> void:
	ENEMY_ATTACK_COOLDOWN = true
	
func attack():
	if Input.is_action_just_pressed("attack"):
		General.PLAYER_CURRENT_ATTACK = true
		ATTACK_IP = true
		var anim = $AnimatedSprite2D
		match CURRENT_DIR:
			"right":
				anim.flip_h = false
				anim.play("side_attack")
			"left":
				anim.flip_h = true
				anim.play("side_attack")
			"down":
				anim.play("front_attack")
			"up":
				anim.play("back_attack")
		$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	General.PLAYER_CURRENT_ATTACK = false
	ATTACK_IP = false	
	
func _on_regin_timer_timeout() -> void:
	if HEALTH < 100 and HEALTH > 0:
		heal(20)
