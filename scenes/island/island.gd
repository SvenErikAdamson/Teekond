extends StaticBody2D
class_name Island

@export var encounter_instance: PackedScene = null
@export var encounter_type: PackedScene = null
@export var current_island: bool = false
@export var scouted: bool = false
@export var food: float = 300
@export var water: int = 100

@onready var connector_scene = preload("res://scenes/utility/connector.tscn")
@onready var node_manager = get_node("/root/Game/Level")
@onready var sprite: Sprite2D = $Sprite2D

var show_encounter = null
var in_progress = false
var encounter_in_progress = false
var is_scouted = false

func _ready():
	if encounter_type != null:
		show_encounter = encounter_type.instantiate()
		show_encounter.position.y = -100
		add_child(show_encounter)
		show_encounter.hide()
		
	if current_island:
		scouted = true
		node_manager.current_island = self
		
func _process(_delta):
	if scouted and is_instance_valid(show_encounter):
		show_encounter.show()
	if current_island and !encounter_in_progress:
		check_encounter()
	if scouted:
		sprite.modulate = Color(1,1,1)
	else:
		sprite.modulate = Color(1,0,1)
		
func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("mb_left") and current_island and !in_progress:
		var connector = connector_scene.instantiate()
		in_progress = true
		add_child(connector)
	if event.is_action_pressed("mb_right") and node_manager.check_destination(node_manager.current_island, self):
		node_manager.scout(self)

func check_encounter():
	if current_island and encounter_instance != null and is_instance_valid(show_encounter):
		show_encounter.queue_free()
		in_progress = true
		var encounter = encounter_instance.instantiate()
		encounter.position.y = -60
		encounter.encounter_scene = encounter_type
		add_child(encounter)
		encounter_in_progress = true
