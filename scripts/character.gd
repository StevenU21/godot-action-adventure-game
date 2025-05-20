extends CharacterBody2D

class_name BaseCharacter

var HEALTH: int = 100
var IS_ALIVE: bool = true
@onready var HEALTH_BAR = $health_bar

func _ready():
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	update_health_bar()

func take_damage(amount: int) -> void:
	if not IS_ALIVE:
		return
	HEALTH -= amount
	update_health_bar()
	if HEALTH <= 0:
		HEALTH = 0
		die()

func heal(amount: int) -> void:
	if IS_ALIVE:
		HEALTH += amount
		if HEALTH > 100:
			HEALTH = 100
		update_health_bar()

func die():
	IS_ALIVE = false
	set_physics_process(false)
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("death")
	if has_node("health_bar"):
		$health_bar.visible = false

func _on_animated_sprite_2d_animation_finished(anim_name = "") -> void:
	if anim_name == "death":
		queue_free()

func update_health_bar():
	if has_node("health_bar"):
		HEALTH_BAR.value = HEALTH
		update_health_bar_color()
		HEALTH_BAR.visible = HEALTH < 100

func update_health_bar_color():
	if not has_node("health_bar"):
		return
	if HEALTH >= 75:
		HEALTH_BAR.modulate = Color("00ff00")
	elif HEALTH > 50:
		HEALTH_BAR.modulate = Color("ffff00")
	elif HEALTH > 25:
		HEALTH_BAR.modulate = Color("ff8000")
	else:
		HEALTH_BAR.modulate = Color("ff0000")
