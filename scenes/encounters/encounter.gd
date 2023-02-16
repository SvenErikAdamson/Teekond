extends Node2D

var encounter_scene = null
var encounter = null

var player_hp: int 
var encounter_hp: int

@onready var node_manager = get_node("/root/Game/Level")
@onready var player_animation = $Player/AnimationPlayer
var player_timer := 0.0
var player_rate := 1
var encounter_timer := 0.0
var encounter_rate := 1
var turn: bool = true

func _ready():
	player_animation.play("Idle")
	encounter = encounter_scene.instantiate()
	encounter.position = $EncounterMarker.position
	add_child(encounter)
	player_hp = node_manager.pop * 100
	encounter_hp = 10

func _process(delta: float):
	if turn:
		player_timer += delta
	elif !turn:
		encounter_timer += delta
		
	if player_timer >= player_rate and turn:
		player_animation.speed_scale = 0.8
		player_animation.play("Attack")
		
	elif encounter_timer >= encounter_rate and !turn:
		encounter.animation_player.speed_scale = 0.8
		encounter.animation_player.play("Attack")
	
	if encounter_hp <= 0:
		get_parent().encounter_instance = null
		get_parent().in_progress = false
		queue_free()
		
func player_attack():
	encounter.animation_player.play("Damage")
	player_damage(randf_range(0,node_manager.pop))
	turn = false
	encounter_timer = 0.0
	player_animation.speed_scale = 0.5
	player_animation.play("Idle")
	
func encounter_attack():
	player_animation.play("Damage")
	encounter_damage(randf_range(0,3))
	turn = true
	player_timer = 0.0
	encounter.animation_player.speed_scale = 0.5
	encounter.animation_player.play("Idle")
	
func encounter_damage(damage):
	print("Encounter did: " + str(damage) + " Damage")
	player_hp -= damage

func player_damage(damage):
	print("Player did: " + str(damage) + " Damage")
	encounter_hp -= damage
