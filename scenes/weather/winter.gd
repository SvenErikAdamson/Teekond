extends Area2D

var winter_speed: float = 50.0
@onready var node_manager = get_node("/root/Game/Level")

func _process(delta):
	self.position.x += delta * winter_speed

func _on_body_entered(body):
	if body is Island:
		if body.current_island:
			node_manager.player_in_winter = true

func _on_body_exited(body):
	if body is Island:
		if body.current_island:
			node_manager.player_in_winter = false
