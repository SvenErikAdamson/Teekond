extends Node2D

var game_on: bool = false

func _on_start_area_mouse_entered():
	game_on = true
	print("game started")

func _on_game_area_mouse_entered():
	pass # Replace with function body.

func _on_game_area_mouse_exited():
	game_on = false
	print("lost")


func _on_win_area_mouse_entered():
	if game_on:
		print("Won!")

