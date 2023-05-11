extends Control
var over: bool = false
func _ready():
	pass
func _process(delta):
	if over:
		visible = !visible
		get_tree().paused = visible

func _on_replay_pressed():
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed():
	get_tree().quit()
