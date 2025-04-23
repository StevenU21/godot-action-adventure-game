extends CharacterBody2D

var SPEED = 40
var PLAYER_CHASE = false
var PLAYER = null
var HEALTH = 100
var PLAYER_IN_ATTACK_ZONE = false
var CAN_TAKE_DAMAGE = true 

func _physics_process(delta):
	deal_with_damage()
	
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
		if PLAYER_IN_ATTACK_ZONE and General.PLAYER_CURRENT_ATTACK == true:
			if CAN_TAKE_DAMAGE == true:
				HEALTH = HEALTH - 20
				$take_damage_cooldown.start()
				CAN_TAKE_DAMAGE = false
				print("slime health = ", HEALTH)
				if HEALTH <= 0:
					self.queue_free()
				
func _on_take_damage_cooldown_timeout() -> void:
	CAN_TAKE_DAMAGE = true
