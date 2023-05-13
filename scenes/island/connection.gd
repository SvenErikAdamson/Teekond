extends Line2D

@export var node1: Node 
@export var node2: Node

@onready var mid_sprite = $Sprite2D
@onready var node_manager = get_node("/root/Game/Level")

func _ready():
	await get_tree().create_timer(randf_range(0.1,0.3))
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", 4.0 , 1).as_relative()
	tween.tween_interval(0.1)
	tween.tween_property(self, "position:y", -4.0 , 1).as_relative()
	tween.tween_interval(0.1)
	mid_sprite.hide()
	set_point_position(0,node1.global_position - global_position)
	set_point_position(1,node2.global_position - global_position)
	node_manager.add_connection(node1,node2)
	node_manager.add_connection(node2,node1)
