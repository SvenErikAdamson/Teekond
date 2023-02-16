extends Node2D

var node_list: Dictionary
var current_island: Node

var food: float = 10
var water: int = 20
var pop: int = 5

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
	if !node.is_scouted and !node.scouted:
		pop -= 1
		node.is_scouted = true
		await get_tree().create_timer(2).timeout
		node.scouted = true
		node.is_scouted = false
