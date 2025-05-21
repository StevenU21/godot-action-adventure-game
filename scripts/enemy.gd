extends "res://scripts/character.gd"

var SPEED = 40
var PLAYER_CHASE = false
var PLAYER = null
var PLAYER_IN_ATTACK_ZONE = false
var CAN_TAKE_DAMAGE = true 
var IS_DYING := false

func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	update_health_bar()

func _physics_process(_delta):
	deal_with_damage()
	if IS_DYING or not IS_ALIVE:
		return
	update_health_bar()
	
	if PLAYER_CHASE:
		position += (PLAYER.position - position)/SPEED
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = (PLAYER.position.x - position.x) < 0
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	PLAYER = body
	PLAYER_CHASE = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	PLAYER = null
	PLAYER_CHASE = false
	
func enemy():
	pass

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		PLAYER_IN_ATTACK_ZONE = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		PLAYER_IN_ATTACK_ZONE = false
		
func deal_with_damage():
	if IS_DYING or not IS_ALIVE:
		return

	if PLAYER_IN_ATTACK_ZONE and General.PLAYER_CURRENT_ATTACK and CAN_TAKE_DAMAGE:
		take_damage(30)
		CAN_TAKE_DAMAGE = false
		$take_damage_cooldown.start()
		print("slime health =", HEALTH)

		if HEALTH <= 0:
			die()

func die():
	IS_DYING = true
	set_physics_process(false)
	$detection_area/CollisionShape2D.disabled = true
	$enemy_collision.disabled = true
	$enemy_hitbox/enemy_hit_area.disabled = true
	if has_node("health_bar"):
		$health_bar.queue_free()
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("death")

func _on_animated_sprite_2d_animation_finished(anim_name = "") -> void:
	if anim_name == "death":
		queue_free()

func _on_take_damage_cooldown_timeout() -> void:
	CAN_TAKE_DAMAGE = true
