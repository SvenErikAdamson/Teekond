extends Node2D

var damage: String = ""

func _ready():
	$HBoxContainer/Label.text = damage
	$AnimationPlayer.play("Lost pop")
	

func destroy():
	queue_free()
