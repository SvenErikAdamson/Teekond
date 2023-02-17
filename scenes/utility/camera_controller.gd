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

func _input(event):
	if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					zoom += Vector2.ONE * zoom_percentage / 100
					if zoom.x > max_zoom:
						zoom = Vector2.ONE * max_zoom
						return
					position += get_local_mouse_position() / 10
				if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					zoom -= Vector2.ONE * zoom_percentage / 100
					if zoom.x < max_unzoom:
						zoom = Vector2.ONE * max_unzoom
