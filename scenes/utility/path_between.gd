extends Path2D

var speed: float = 1.0
var from: Node
var to: Node

@onready var node_manager = get_node("/root/Game/Level")
@onready var pathfollow = $PathFollow2D

func _physics_process(delta):
	speed = 1.0 -  node_manager.exhaustion * 0.1
	pathfollow.progress_ratio += delta * speed
	if pathfollow.progress_ratio >= 1:
		from.current_island = false
		to.current_island = true
		node_manager.current_island = to
		from.in_progress = false
		to.in_progress = false
		to.scouted = true
		queue_free()
