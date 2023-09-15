extends Camera2D

var speed = 50
var zoom_percentage = 10
var max_zoom = 1.5
var max_unzoom = 0.4

func _physics_process(_delta):
	if Input.is_action_pressed("key_left"):
		position.x -= speed
	if Input.is_action_pressed("key_right"):
		position.x += speed
	if Input.is_action_pressed("key_up"):
		position.y -= speed
	if Input.is_action_pressed("key_down"):
		position.y += speed
