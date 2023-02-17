extends Line2D

@onready var node_manager = get_node("/root/Game/Level")
@onready var path_scene = preload("res://scenes/utility/path_between.tscn")
@onready var tip = $Hand

var from: Node
var focused_island = null
var can_move: bool = false

func _ready():
	from = get_parent()
	
func _process(_delta):
	set_positions()
	if Input.is_action_just_released("mb_left") and focused_island != null and node_manager.exhaustion <= 90:
		print("Can travel to node: " + str(node_manager.check_destination(from,focused_island)))
		if node_manager.check_destination(from,focused_island):
			create_path()
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
	
func create_path():
	var path = path_scene.instantiate()
	path.curve.clear_points()
	path.curve.add_point(from.global_position - global_position)
	path.curve.add_point(focused_island.global_position - global_position)
	path.to = focused_island
	path.from = from
	get_parent().add_child(path)
	
func _on_hand_body_entered(body):
	if body is Island and body != from:
		can_move = true
		focused_island = body
		
func _on_hand_body_exited(body):
	if body is Island and body != from:
		can_move = false
		focused_island = null
