extends Control

@onready var menu = $Menu
@onready var options = $Options
@onready var video = $Video
@onready var audio = $Audio

func _on_start_pressed():
	get_tree().change_scene_to_file("res://game.tscn")

func _on_editor_pressed():
	get_tree().change_scene_to_file("res://scenes/editor/editor.tscn")
	
func _on_options_pressed():
	show_and_hide(options, menu)
	
func show_and_hide(to_show,to_hide):
	to_show.show()
	to_hide.hide()

func _on_exit_pressed():
	get_tree().quit()

func _on_video_pressed():
	show_and_hide(video,options)
	
func _on_audio_pressed():
	show_and_hide(audio,options)

func _on_back_from_options_pressed():
	show_and_hide(menu,options)

##Find how that works
#func _on_full_screen_toggled(button_pressed):
#	DisplayServer.WINDOW_MODE_FULLSCREEN
#
#func _on_borderless_toggled(button_pressed):
#	DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
#
#func _on_v_sync_toggled(button_pressed):
#	DisplayServer.VSYNC_ENABLED

func _on_back_from_video_pressed():
	show_and_hide(options, video)

func _on_master_value_changed(value):
	volume(0,value)

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index,value)

func _on_music_value_changed(value):
	volume(1,value)

func _on_sound_fx_value_changed(value):
	volume(2,value)

func _on_back_from_audio_pressed():
	show_and_hide(options, audio)

