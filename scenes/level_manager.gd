extends Node2D

var node_list: Dictionary
var current_island: Node

var food: float = 25
var water: int = 20
var pop: int = 5
var exhaustion: float = 3.8 
var max_exhaustion: float = 100.0
var speed_modifier: float = 1.0

@onready var scouting_indicator_scene = load("res://scenes/island/indicators/scouting_indicator.tscn")

func _process(delta):
	use_rations(delta)
	
func add_connection(node, con):
	if !node_list.has(node):
		node_list[node] = []
	node_list[node].append(con)

func check_destination(from, to):
	if node_list[from].has(to):
		return true
	else:
		return false

func scout(node):
	if !node.is_scouted and !node.scouted and food > 8:
		food -= 5
		var scouting_indicator = scouting_indicator_scene.instantiate()
		node.add_child(scouting_indicator)
		pop -= 1
		node.is_scouted = true
		await get_tree().create_timer(2).timeout
		pop += 1
		node.scouted = true
		node.is_scouted = false
		scouting_indicator.free()

func use_rations(delta):
	food -= delta
