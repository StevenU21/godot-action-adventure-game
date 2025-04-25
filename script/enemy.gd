extends CharacterBody2D

var SPEED = 40
var PLAYER_CHASE = false
var PLAYER = null
var HEALTH = 100
var PLAYER_IN_ATTACK_ZONE = false
var CAN_TAKE_DAMAGE = true 
var IS_DYING := false
@onready var HEALTH_BAR = $health_bar

func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _physics_process(_delta):
	deal_with_damage()
	if IS_DYING:
		return
	update_health()
	
	if PLAYER_CHASE:
		position += (PLAYER.position - position)/SPEED
		$AnimatedSprite2D.play("walk")
		if(PLAYER.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
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
	if IS_DYING:
		return

	if PLAYER_IN_ATTACK_ZONE and General.PLAYER_CURRENT_ATTACK and CAN_TAKE_DAMAGE:
		HEALTH -= 30
		CAN_TAKE_DAMAGE = false
		$take_damage_cooldown.start()
		print("slime health =", HEALTH)

		if HEALTH <= 0:
			die()
			await $AnimatedSprite2D.animation_finished
			queue_free()

func die():
	IS_DYING = true
	set_physics_process(false)
	$detection_area/CollisionShape2D.disabled = true
	$enemy_collision.disabled = true
	$enemy_hitbox/enemy_hit_area.disabled = true
	$health_bar.queue_free()
	$AnimatedSprite2D.play("death")
	
func _on_animated_sprite_2d_animation_finished(anim_name) -> void:
	if anim_name == "death":
		queue_free()

func _on_take_damage_cooldown_timeout() -> void:
	CAN_TAKE_DAMAGE = true
	
func update_health():
	HEALTH_BAR.value = HEALTH
	update_health_bar_color()
	
	if HEALTH >= 100:
		HEALTH_BAR.visible = false
	else:
		HEALTH_BAR.visible = true
		
func update_health_bar_color():

	if HEALTH >= 60 and HEALTH <= 100:
		HEALTH_BAR.modulate = Color("00ff00")
	elif HEALTH > 30 and HEALTH <= 59:
		HEALTH_BAR.modulate = Color("ffff00")
	elif HEALTH >= 0 and HEALTH <= 29:
		HEALTH_BAR.modulate = Color("ff8000")
	else:
		HEALTH_BAR.modulate = Color("ff0000")
