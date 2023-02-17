extends Node2D

var encounter_scene = null
var encounter = null

var player_hp: int 
var lost_hp: int
var encounter_hp: int

@onready var node_manager = get_node("/root/Game/Level")
@onready var player_animation = $Player/AnimationPlayer
@onready var damage_label = load("res://scenes/encounters/ui/damage_label.tscn")

var player_timer := 0.0
var player_rate := 1
var encounter_timer := 0.0
var encounter_rate := 1
var turn: bool = true

func _ready():
	node_manager.player_in_combat = true
	player_animation.play("Idle")
	player_hp = node_manager.pop * 100
	create_encounter()
		
func _process(delta: float):
	check_death()
	combat(delta)
		
func create_encounter():
	encounter = encounter_scene.instantiate()
	encounter.position = $EncounterMarker.position
	add_child(encounter)
	if encounter != null:
		encounter_hp = encounter.health
		
func combat(delta):
	if turn:
		player_timer += delta
	elif !turn:
		encounter_timer += delta
	if player_timer >= player_rate and turn:
		player_animation.speed_scale = 1.5
		player_animation.play("Attack")
	elif encounter_timer >= encounter_rate and !turn:
		encounter.animation_player.speed_scale = 0.8
		encounter.animation_player.play("Attack")
	if encounter_hp <= 0:
		get_parent().encounter_type = null
		get_parent().in_progress = false
		node_manager.player_in_combat = false
		queue_free()
		
func player_attack():
	encounter.animation_player.play("Damage")
	node_manager.exhaustion += 0.5
	player_damage(randf_range(0,node_manager.pop))
	turn = false
	encounter_timer = 0.0
	player_animation.speed_scale = 0.5
	player_animation.play("Idle")
	
func encounter_attack():
	player_animation.play("Damage")
	encounter_damage(randf_range(encounter.min_dmg,encounter.max_dmg))
	turn = true
	player_timer = 0.0
	encounter.animation_player.speed_scale = 0.5
	encounter.animation_player.play("Idle")
	
func encounter_damage(damage):
	damage_txt_anim($Player.global_position,damage, $Player)
	player_hp -= damage
	lost_hp += damage
	
func player_damage(damage):
	damage_txt_anim($EncounterMarker.global_position,damage, encounter)
	encounter_hp -= damage

func damage_txt_anim(pos, amount, spot):
	var dmg_label = damage_label.instantiate()
	spot.add_child(dmg_label)
	dmg_label.global_position = pos
	dmg_label.text = str(int(amount))
	
func check_death():
	if lost_hp >= 100:
		lost_hp -=100
		node_manager.pop -= 1
