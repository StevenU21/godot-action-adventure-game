extends Node

var PLAYER_CURRENT_ATTACK = false

var CURRENT_SCENE = "world"
var TRANSITION_SCENE = false

var PLAYER_EXIT_CLIFFSIDE_POSX = 250
var PLAYER_EXIT_CLIFFSIDE_POSY = 35
var PLAYER_START_POSX = 36
var PLAYER_EXIT_POSY = 88

var GAME_FIRST_LOADING = true

func finish_change_scenes():
	if TRANSITION_SCENE == true:
		TRANSITION_SCENE = false
		if CURRENT_SCENE == "world":
			CURRENT_SCENE = "cliff_side"
		else:
			CURRENT_SCENE = "world"
	print("Después de cambiar: ", CURRENT_SCENE)
