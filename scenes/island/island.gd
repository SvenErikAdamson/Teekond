extends StaticBody2D
class_name Island

@export_category("Island Data")
@export var encounter_type: PackedScene = null
@export var current_island: bool = false
@export var scouted: bool = false
@export var food: float = 300.0
@export var pop: int = 0
@export var water: int = 100
@export var harshness: float = 2.0

@export_category("Additional")
@export var key_needed: String
@export var connnection_opened: Node 

@export_category("On Island")
@export var item: Resource = null
@export var key: String

@onready var encounter_scene = preload("res://scenes/encounters/encounter.tscn")
@onready var connector_scene = preload("res://scenes/utility/connector.tscn")
@onready var icon = load("res://scenes/ui/ingame/icon.tscn")
@onready var node_manager = get_node("/root/Game/Level")
@onready var sprite: Sprite2D = $Sprite2D
@onready var camp: Node2D = $Camp
@onready var hover_indicator = $HoverIndicator

var max_food: float
var show_encounter = null
var in_progress: bool = false
var encounter_in_progress: bool = false
var is_scouted: bool = false
var is_combat_on: bool = false

func _ready():
	create_encounter()
	max_food = food
	if current_island:
		food_state()
		scouted = true
		node_manager.current_island = self
#	await get_tree().create_timer(randf_range(0,3)).timeout
#	$AnimationPlayer.play("Hover")
		
func _process(delta):
	forage(delta)
	if current_island:
		food_state()
		camp.show()
		node_manager.add_key(key)
	else:
		camp.hide()
	if scouted and is_instance_valid(show_encounter):
		show_encounter.show()
	if current_island and !encounter_in_progress:
		check_encounter()
	if scouted:
		food_state()
		sprite.modulate = Color(1,1,1)
	else:
		sprite.modulate = Color(0,0,0)
		
func food_state():
	if calc_percentage(food, max_food) >= 90.0:
		draw_icons(3)
		sprite.set_frame(0)
	elif calc_percentage(food, max_food) >= 50.0:
		sprite.set_frame(1)
		draw_icons(2)
	elif calc_percentage(food, max_food) >= 30.0:
		draw_icons(1)
		sprite.set_frame(2)
	else:
		sprite.set_frame(3)
		
func draw_icons(amount):
	for child in $IconContainer.get_children():
		child.queue_free()
	var offset = 0
	for i in amount:
		var ico = icon.instantiate()
		$IconContainer.add_child(ico)
		ico.position.x = offset -30
		ico.position.y = 50
		offset += 25
		
func forage(delta):
	if current_island:
		if food >= 0:
			food -= delta * node_manager.forage_modifier
			node_manager.food += delta
		if pop >= 0:
			node_manager.pop += pop
			pop = 0
			
		
func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("mb_left") and current_island and !in_progress:
		var connector = connector_scene.instantiate()
		in_progress = true
		add_child(connector)
	if event.is_action_pressed("mb_right") and node_manager.check_destination(node_manager.current_island, self):
		node_manager.scout(self)

func calc_percentage(part_val, tot_val):
	return (part_val / tot_val)* 100
	
func create_encounter():
	if encounter_type != null:
		show_encounter = encounter_type.instantiate()
		show_encounter.position.y = -60
		add_child(show_encounter)
		show_encounter.hide()

func check_encounter():
	if current_island and encounter_type != null and is_instance_valid(show_encounter):
		show_encounter.queue_free()
		in_progress = true
		var encounter = encounter_scene.instantiate()
		encounter.position.y = -60
		encounter.encounter_scene = encounter_type
		add_child(encounter)
		encounter_in_progress = true
