extends Line2D

@onready var level_manager = get_node("/root/Game/Level")
@onready var path_scene = preload("res://scenes/utility/path_between.tscn")
@onready var tip = $Hand

var from: Node
var focused_island = null
var can_move: bool = false

func _ready():
	from = get_parent()
	
func _process(_delta):
	set_positions()
	if Input.is_action_just_released("mb_left") and focused_island != null:
		var distance = from.position.distance_to(focused_island.position)
		print("Can travel to node: " + str(level_manager.check_destination(from,focused_island)))
		if level_manager.check_destination(from,focused_island):
			create_path(distance)
			queue_free()
		else:
			from.in_progress = false
			queue_free()
	elif Input.is_action_just_released("mb_left"):
		from.in_progress = false
		queue_free()

func set_positions():
	tip.global_position = get_global_mouse_position()
	set_point_position(1,get_local_mouse_position())
	
func create_path(distance):
	var path = path_scene.instantiate()
	path.speed = 1.0 / (distance / 500)
	path.curve.clear_points()
	path.curve.add_point(from.global_position - global_position)
	path.curve.add_point(focused_island.global_position - global_position)
	path.to = focused_island
	path.from = from
	get_parent().add_child(path)
	
func _on_hand_body_entered(body):
	if body is Island and body != from:
		body.hover_indicator.show()
		can_move = true
		focused_island = body
		
func _on_hand_body_exited(body):
	if body is Island and body != from:
		body.hover_indicator.hide()
		can_move = false
		focused_island = null
