extends Node2D

var island_list: Dictionary
var current_island: Node
var hovered_island:  Node
var last_island:  Node

@export var forage_modifier: float = 3.0
@export var combat_modifier: float = 1.0
@export var rest_modifier: float = 1.0
@export var winter_modifier: float = 2.0
@export var food: float = 1
@export var water: int = 20
@export var pop: int = 5

var player_in_combat: bool = false
var player_is_moving: bool = false
var player_in_winter: bool = false

@onready var game_over = $"../UI/GameOver"
@onready var scouting_indicator_scene = load("res://scenes/island/indicators/scouting_indicator.tscn")

func _process(delta):
	use_rations(delta)
	check_rations()
	#This will need to hop off to be only checked when on new island
	forage_modifier = pop * 1.0
	
func add_connection(island, con):
	if !island_list.has(island):
		island_list[island] = []
	island_list[island].append(con)

func get_distance(from,to):
	return from.distance_to(to)
	
func check_destination(from, to):
	if island_list[from].has(to):
		return true
	else:
		return false

#Messy, needs work
func scout(island):
	if !island.is_scouted and !island.scouted and food > 8:
		food -= 5
		var scouting_indicator = scouting_indicator_scene.instantiate()
		island.add_child(scouting_indicator)
		pop -= 1
		island.is_scouted = true
		await get_tree().create_timer(2).timeout
		pop += 1
		island.scouted = true
		island.is_scouted = false
		scouting_indicator.free()

func use_rations(delta):
	if player_in_winter:
		food -= delta * winter_modifier * (float(pop) / 2)
	else:
		food -= delta
		
func check_rations():
	if food <= 0 || water <= 0:
		game_over.over = true
		game_over.show()
		
