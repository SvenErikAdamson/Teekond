extends Node2D

var encounter = null
var player_hp: int 
var encounter_hp: int

@onready var node_manager = get_node("/root/Game/Level")

var player_timer := 0.0
var player_rate := 1
var encounter_timer := 0.0
var encounter_rate := 2
var turn: bool = true

func _ready():
	player_hp = node_manager.pop * 100
	encounter_hp = 10

func _process(delta: float):
	if turn:
		player_timer += delta
	elif !turn:
		encounter_timer += delta
		
	if player_timer >= player_rate and turn:
		player_damage(randf_range(0,node_manager.pop))
		print("Player HP: " + str(player_hp) + " Encounter HP: " + str(encounter_hp))
		turn = false
		encounter_timer = 0.0
		
	elif encounter_timer >= encounter_rate and !turn:
		encounter_damage(randf_range(0,3))
		print("Player HP: " + str(player_hp) + " Encounter HP: " + str(encounter_hp))
		turn = true
		player_timer = 0.0
	
	if encounter_hp <= 0:
		get_parent().encounter_instance = null
		get_parent().in_progress = false
		queue_free()
		
func encounter_damage(damage):
	print("Encounter did: " + str(damage) + " Damage")
	player_hp -= damage

func player_damage(damage):
	print("Player did: " + str(damage) + " Damage")
	encounter_hp -= damage
