extends CharacterBody2D

var SPEED = 25
var PLAYER_CHASE = false
var PLAYER = null

func _physics_process(delta):
	if PLAYER_CHASE:
		position += (PLAYER.position - position)/SPEED

func _on_detection_area_body_entered(body: Node2D) -> void:
	PLAYER = body
	PLAYER_CHASE = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	PLAYER = null
	PLAYER_CHASE = false
