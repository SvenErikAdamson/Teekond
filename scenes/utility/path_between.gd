extends Path2D

var speed: float = 1.0
var from: Node
var to: Node
var retreat: bool = false
@onready var level_manager = get_node("/root/Game/Level")
@onready var pathfollow = $PathFollow2D

func _ready():
	level_manager.player_is_moving = true
	
func _physics_process(delta):
	pathfollow.progress_ratio += delta * speed
	if !retreat:
		if pathfollow.progress_ratio >= 1:
			from.current_island = false
			to.current_island = true
			level_manager.current_island = to
			from.in_progress = false
			to.in_progress = false
			to.scouted = true
			level_manager.player_is_moving = false
			level_manager.exhaustion += from.harshness
			level_manager.last_island = from
			SoundPlayer.play_sound(SoundPlayer.CLICK)
			queue_free()

	if retreat:
		if pathfollow.progress_ratio >= 1:
			from.current_island = false
			to.current_island = true
			level_manager.current_island = to
			level_manager.last_island = from
			from.in_progress = false
			to.in_progress = false
			to.scouted = true
			level_manager.last_island = from
			level_manager.player_is_moving = false
			SoundPlayer.play_sound(SoundPlayer.CLICK)
			queue_free()
