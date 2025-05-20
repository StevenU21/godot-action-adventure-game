extends Node2D

@onready var panel = $Warning_Message/Panel
@export var target_scene_path: String = General.SCENES["cliff_side"]
@export var exit_name: String = "main_entry"

func _ready():
	General.current_scene_name = "main"
	General.place_player_at_last_exit(self)

func _on_cliffside_transition_point_body_entered(body: Node2D) -> void:
	if body.name == "player":
		General.change_scene(
			target_scene_path, 
			exit_name,          
			"cliff_side"              
		)
		
func _on_forbidden_zone_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		$Warning_Message.visible = true

func _on_forbidden_zone_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		$Warning_Message.visible = false
