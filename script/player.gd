extends CharacterBody2D

const SPEED = 100
var CURRENT_DIR = "down"
var ENEMY_IN_ATTACK_RANGE = false
var ENEMY_ATTACK_COOLDOWN = true
var HEALTH = 100
var PLAYER_ALIVE = true
var ATTACK_IP = false
	
func _ready():
	$AnimatedSprite2D.play("front_idle")
	$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _physics_process(_delta: float):
	if not PLAYER_ALIVE:
		return
		
	current_camera()
	player_movement(_delta)
	enemy_attack()
	attack()
	update_health_bar()
	
	if HEALTH <= 0:
		HEALTH = 0
		PLAYER_ALIVE = false
		die()
		return
		
func die():
	PLAYER_ALIVE = false
	set_physics_process(false)
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("death")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		get_tree().reload_current_scene()

func player_movement(_delta):
	
	if Input.is_action_pressed("move_right"):
		CURRENT_DIR = "right"
		play_animation(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("move_left"):
		CURRENT_DIR = "left"
		play_animation(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("move_down"):
		CURRENT_DIR = "down"
		play_animation(1)
		velocity.y = SPEED
		velocity.x = 0
	elif Input.is_action_pressed("move_up"):
		CURRENT_DIR = "up"
		play_animation(1)
		velocity.y = -SPEED
		velocity.x = 0
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()
	
func play_animation(movement):
	var dir = CURRENT_DIR
	var animation = $AnimatedSprite2D
	
	if dir == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if ATTACK_IP == false:
				animation.play("side_idle")
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if ATTACK_IP == false:
				animation.play("side_idle")
	if dir == "down":
		animation.flip_h = true
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			if ATTACK_IP == false:
				animation.play("front_idle")
	if dir == "up":
		animation.flip_h = true
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			if ATTACK_IP == false:
				animation.play("back_idle")
			
func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		ENEMY_IN_ATTACK_RANGE = true
	
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		ENEMY_IN_ATTACK_RANGE = false
		
func enemy_attack():
	if ENEMY_IN_ATTACK_RANGE and ENEMY_ATTACK_COOLDOWN == true :
		HEALTH = HEALTH - 20
		ENEMY_ATTACK_COOLDOWN = false
		$attack_cooldown.start()
		print(HEALTH)

func _on_attack_cooldown_timeout() -> void:
	ENEMY_ATTACK_COOLDOWN = true
	
func attack():
	var dir = CURRENT_DIR
	
	if Input.is_action_just_pressed("attack"):
		General.PLAYER_CURRENT_ATTACK = true
		ATTACK_IP = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
			
			
func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	General.PLAYER_CURRENT_ATTACK = false
	ATTACK_IP = false	
	
func current_camera():
	if General.CURRENT_SCENE == "world":
		$world_camera.enabled = true
		$cliff_side_camera.enabled = false
	elif General.CURRENT_SCENE == "cliff_side":
		$world_camera.enabled = false
		$cliff_side_camera.enabled = true

func update_health_bar():
	var health_bar = $health_bar
	health_bar.value = HEALTH
	
	if HEALTH >= 100:
		health_bar.visible = false
	else:
		health_bar.visible = true	

func _on_regin_timer_timeout() -> void:
	if HEALTH < 100 and HEALTH > 0:
		HEALTH = HEALTH + 20
		if HEALTH > 100:
			HEALTH = 100
	if HEALTH <= 0:
		PLAYER_ALIVE = false
		HEALTH = 0
