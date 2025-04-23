extends Node2D
	
func _process(_delta: float) -> void:
	change_scenes()

func _on_cliff_side_exit_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		General.TRANSITION_SCENE = true 

func _on_cliff_side_exit_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		General.TRANSITION_SCENE = false

func change_scenes():
	if General.TRANSITION_SCENE == true:
		print("Antes de cambiar: ", General.CURRENT_SCENE)
		if General.CURRENT_SCENE == "cliff_side":
			General.CURRENT_SCENE =  "world"
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			General.finish_change_scenes()
	
