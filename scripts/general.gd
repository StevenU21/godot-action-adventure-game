extends Node

var PLAYER_CURRENT_ATTACK = false
var last_visited_area: String = ""
var current_scene_name: String = "main"
var TRANSITION_SCENE = false
var GAME_FIRST_LOADING = true

const SCENES = {
	"main": "res://scenes/main.tscn",
	"cliff_side": "res://scenes/cliff_side.tscn",
}

var camera_limits = {
	"main": {"left": 0, "right": 436, "top": 0, "bottom": 246},
	"cliff_side": {"left": -80, "right": 416, "top": -64, "bottom": 210},
}

func change_scene(target_scene_path: String, exit_name: String, scene_name: String) -> void:
	last_visited_area = exit_name
	current_scene_name = scene_name
	get_tree().change_scene_to_file(target_scene_path)

func place_player_at_last_exit(scene_root: Node) -> void:
	var player = scene_root.get_node_or_null("player")
	if not player:
		return

	for marker in get_tree().get_nodes_in_group("exit_groups"):
		if marker.name == last_visited_area:
			player.global_position = marker.global_position
			break

	var camera = player.get_node_or_null("Camera2D")
	if camera:
		adjust_camera_to_scene(camera)

func adjust_camera_to_scene(camera: Camera2D) -> void:
	if current_scene_name in camera_limits:
		var limits = camera_limits[current_scene_name]
		camera.limit_left = limits["left"]
		camera.limit_right = limits["right"]
		camera.limit_top = limits["top"]
		camera.limit_bottom = limits["bottom"]
