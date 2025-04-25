extends Node2D

@onready var panel = $Warning_Message/Panel

func _ready():
	if General.GAME_FIRST_LOADING == true:
		$player.position.x = General.PLAYER_START_POSX
		$player.position.y = General.PLAYER_EXIT_POSY
	else:
		$player.position.x = General.PLAYER_EXIT_CLIFFSIDE_POSX
		$player.position.y = General.PLAYER_EXIT_CLIFFSIDE_POSY
		$forbidden_zone.body_entered.connect(self._on_forbidden_zone_body_entered)
	$forbidden_zone.body_entered.connect(self._on_forbidden_zone_body_entered)
	$forbidden_zone.body_exited.connect(self._on_forbidden_zone_body_exited)

func _process(delta: float):
	change_scene()
	
func _on_cliffside_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		General.TRANSITION_SCENE = true

func _on_cliffside_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		General.TRANSITION_SCENE = false
		
func change_scene():
	if General.TRANSITION_SCENE == true:
		print("Antes de cambiar: ", General.CURRENT_SCENE)
		if General.CURRENT_SCENE == "world":
			General.CURRENT_SCENE = "cliff_side"
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			General.GAME_FIRST_LOADING = false
			General.finish_change_scenes()
			

func _on_forbidden_zone_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		$Warning_Message.visible = true

func _on_forbidden_zone_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		$Warning_Message.visible = false
