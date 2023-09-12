extends Control
var over: bool = false
func _ready():
	pass
func _process(_delta):
	if over:
		get_tree().paused = visible

func _on_replay_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = !visible


func _on_quit_pressed():
	get_tree().quit()
