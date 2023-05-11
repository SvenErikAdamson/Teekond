extends Node2D

var island_list: Dictionary
var current_island: Node
var hovered_island:  Node
var last_island:  Node


@export var forage_modifier: float = 3.0
@export var combat_modifier: float = 1.0
@export var rest_modifier: float = 1.0
@export var winter_modifier: float = 2.0
@export var food: float = 25
@export var water: int = 20
@export var pop: int = 5

var exhaustion: float = 0.0
var key_list: Array

var player_in_combat: bool = false
var player_is_moving: bool = false
var player_in_winter: bool = false

@onready var scouting_indicator_scene = load("res://scenes/island/indicators/scouting_indicator.tscn")

func _process(delta):
	exhaustion_check()
	use_rations(delta)
	rest(delta)
	game_over_check()
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

func rest(delta):
	if !player_in_combat and !player_is_moving and exhaustion > 0:
		exhaustion -= delta * rest_modifier

func exhaustion_check():
	if exhaustion >= 100:
		exhaustion = 100
	elif exhaustion < 0:
		exhaustion = 0

func game_over_check():
	if pop <= 0:
		$"../UI/GameOver".visible
		$"../UI/GameOver".over = true
