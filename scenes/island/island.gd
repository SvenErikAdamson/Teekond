extends StaticBody2D
class_name Island

@export_category("Island Data")
@export var creature_scene: PackedScene = null
@export var current_island: bool = false
@export var scouted: bool = false
@export var food: float = 300.0
@export var pop: int = 0
@export var harshness: float = 2.0
@export_category("Island Challenges")
@export var key: String
@export var minigame_scene: PackedScene = null

@onready var combat_scene = preload("res://scenes/encounters/combat.tscn")
@onready var connector_scene = preload("res://scenes/utility/connector.tscn")
@onready var food_icon_scene = load("res://scenes/ui/ingame/food_icon.tscn")
@onready var pop_icon_scene = load("res://scenes/ui/ingame/pop_icon.tscn")
@onready var level_manager = get_node("/root/Game/Level")
@onready var key_icon = $Icons/Key
@onready var sprite: Sprite2D = $Sprite2D
@onready var hover_indicator = $HoverIndicator
@onready var state_anim = $PlayerState/AnimSprite

var creature_instance

var in_progress: bool = false
var is_scouted: bool = false
var has_encounter: bool = false
var is_combat_init: bool = false
var is_in_minigame: bool = false

func _ready():
	set_variables()
	if creature_scene != null:
		has_encounter = true
		create_creature_prop()
	else:
		has_encounter = false
		
func end_combat():
	is_combat_init = false
	
func create_creature_prop():
	creature_instance = creature_scene.instantiate()
	creature_instance.position = $EnemyPosition.position
	add_child(creature_instance)

func check_for_combat():
	if !is_combat_init and has_encounter and current_island:
		var combat = combat_scene.instantiate()
		combat.creature_scene = creature_scene
		add_child(combat)
		combat.position = $CombatPosition.position
		is_combat_init = true
		
func _process(delta):
	key_control()
	check_island_state(delta)
	if !current_island or is_combat_init:
		state_anim.hide()
		
func key_control():
	if key != "":
		key_icon.show()
	if current_island and key != "":
		level_manager.key_list.append(key)
		key = ""
		key_icon.hide()
		
func icon_state():
	if food >= 90.0:
		clear_icons($Icons/Food)
		draw_food_icon(5)
	elif food >= 50.0:
		clear_icons($Icons/Food)
		draw_food_icon(4)
	elif food >= 30.0:
		clear_icons($Icons/Food)
		draw_food_icon(3)
	elif food >= 15.0:
		clear_icons($Icons/Food)
		draw_food_icon(2)
	elif food >= 1.0:
		clear_icons($Icons/Food)
		draw_food_icon(1)
	else:
		clear_icons($Icons/Food)
		
	if pop >= 6:
		clear_icons($Icons/Pop)
		draw_pop_icon(6)
	elif pop >= 5:
		clear_icons($Icons/Pop)
		draw_pop_icon(5)
	elif pop >= 4:
		clear_icons($Icons/Pop)
		draw_pop_icon(4)
	elif pop >= 3:
		clear_icons($Icons/Pop)
		draw_pop_icon(3)
	elif pop >= 2:
		clear_icons($Icons/Pop)
		draw_pop_icon(2)
	elif pop >= 1:
		clear_icons($Icons/Pop)
		draw_pop_icon(1)
	else:
		clear_icons($Icons/Pop)
		
func clear_icons(icon):
	for child in icon.get_children():
		child.queue_free()

func draw_pop_icon(amount, posy = 64):
	if food <= 0.0:
		posy = 50
	var offset = 0
	for i in amount:
		var ico = pop_icon_scene.instantiate()
		$Icons/Pop.add_child(ico)
		ico.position.x = offset -30
		ico.position.y = posy
		offset += 15
		
func draw_food_icon(amount, posy = 50):
	var offset = 0
	for i in amount:
		var ico = food_icon_scene.instantiate()
		$Icons/Food.add_child(ico)
		ico.position.x = offset -30
		ico.position.y = posy
		offset += 15
		
func forage(delta):
		if food > 0 and !is_combat_init and !is_in_minigame:
			state_anim.play("Gather")
			food -= delta * level_manager.forage_modifier
			level_manager.food += delta * level_manager.forage_modifier
		else:
			state_anim.play("Idle")
			
func recruit():
		if pop > 0 and !is_combat_init and !is_in_minigame:
			level_manager.pop += pop
			pop = 0

func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("mb_left") and current_island and !in_progress and !is_combat_init and !is_in_minigame:
		var connector = connector_scene.instantiate()
		in_progress = true
		add_child(connector)
	if event.is_action_pressed("mb_right") and level_manager.check_destination(level_manager.current_island, self):
		level_manager.scout(self)

func calc_percentage(part_val, tot_val):
	return (part_val / tot_val)* 100
#
func set_variables():
	if current_island:
		icon_state()
		scouted = true
		level_manager.current_island = self

func create_minigame():
	if minigame_scene != null and !is_in_minigame:
		var minigame = minigame_scene.instantiate()
		add_child(minigame)
		minigame.position = $MiniGamePosition.position
		is_in_minigame = true
		
func check_island_state(delta):
	if current_island:
		check_for_combat()
		forage(delta)
		recruit()
		icon_state()
		create_minigame()
		state_anim.show()
	if scouted:
		icon_state()
		if is_instance_valid(creature_instance):
			creature_instance.show()
		sprite.modulate = Color(1,1,1)
	else:
		if is_instance_valid(creature_instance):
			creature_instance.hide()
		sprite.modulate = Color(0,0,0)
