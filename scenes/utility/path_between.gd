extends Path2D

var speed: float = 1.0
var from: Node
var to: Node
var retreat: bool = false
@onready var node_manager = get_node("/root/Game/Level")
@onready var pathfollow = $PathFollow2D

func _ready():
	node_manager.player_is_moving = true
	
func _physics_process(delta):
	pathfollow.progress_ratio += delta * speed
	if !retreat:
		if pathfollow.progress_ratio >= 1:
			from.current_island = false
			to.current_island = true
			node_manager.current_island = to
			from.in_progress = false
			to.in_progress = false
			to.scouted = true
			node_manager.player_is_moving = false
			node_manager.exhaustion += from.harshness
			node_manager.last_island = from
			SoundPlayer.play_sound(SoundPlayer.CLICK)
			queue_free()

	if retreat:
		if pathfollow.progress_ratio >= 1:
			from.current_island = false
			to.current_island = true
			node_manager.current_island = to
			from.in_progress = false
			to.in_progress = false
			to.scouted = true
			node_manager.player_is_moving = false
			queue_free()
