extends Node2D

@export var target_scene_path: String = General.SCENES["main"]
@export var exit_name: String = "cliff_side_entry"

func _ready():
	General.current_scene_name = "cliff_side"
	General.place_player_at_last_exit(self)

func _on_cliff_side_exit_body_entered(body: Node2D) -> void:
	if body.name == "player":
		General.change_scene(
			target_scene_path, 
			exit_name,          
			"main"              
		)
