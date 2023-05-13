extends Node2D

var creature_scene = null
var creature = null
var player_hp: int 
var lost_hp: int
var creature_hp: int

@onready var island = get_parent()
@onready var level_manager = get_node("/root/Game/Level")
@onready var player_animation = $Player/AnimationPlayer
@onready var damage_label = load("res://scenes/encounters/ui/damage_label.tscn")
@onready var pop_lost = load("res://scenes/ui/ingame/pop_lost.tscn")
@onready var path_scene = preload("res://scenes/utility/path_between.tscn")

var player_timer := 0.0
var player_rate := 0.8
var creature_timer := 0.0
var creature_rate := 0.8
var is_combat_on = false
var turn: bool = true

func _ready():
	$Player.position = $PlayerMarker.position
	is_combat_on = true
	level_manager.player_in_combat = true
	player_animation.play("Idle")
	player_hp = level_manager.pop * 100
	if is_instance_valid(island.creature_instance):
		island.creature_instance.queue_free()
	if creature_scene != null:
		create_creature()

func _process(delta: float):
	check_death()
	combat(delta)


func create_creature():
	creature = creature_scene.instantiate()
	creature.on_click_damage.connect(self.on_click_damage)
	creature.position = $EnemyMarker.position
	creature.in_combat = true
	add_child(creature)
	if creature != null:
		creature_hp = creature.health

func on_click_damage():
	if level_manager.exhaustion <= 95:
		player_damage(1)
		level_manager.exhaustion += 5

func combat(delta):
	if turn:
		player_timer += delta
	elif !turn:
		creature_timer += delta
	if player_timer >= player_rate and turn:
		player_animation.speed_scale = 1.5
		player_animation.play("Attack")
	elif creature_timer >= creature_rate and !turn:
		creature.animation_player.speed_scale = 1.0
		creature.animation_player.play("Attack")
	if creature_hp <= 0:
		creature.animation_player.play("Death")
		island.has_encounter = false
		island.current_island = true
		island.in_progress = false
		level_manager.player_in_combat = false
		island.end_combat()
		is_combat_on = false
		await get_tree().create_timer(1).timeout
		queue_free()

func player_attack():
	SoundPlayer.play_sound(SoundPlayer.MELEE_HIT)
	level_manager.exhaustion += 0.5
	player_damage(randf_range(1,level_manager.pop))
	turn = false
	creature_timer = 0.0
	player_animation.speed_scale = 0.5
	player_animation.play("Idle")

func creature_attack():
	SoundPlayer.play_sound(SoundPlayer.ANIMAL_HIT)
	player_animation.play("Damage")
	creature_damage(randf_range(creature.min_dmg,creature.max_dmg))
	turn = true
	player_timer = 0.0
	creature.animation_player.speed_scale = 0.5
	creature.animation_player.play("Idle")

func creature_damage(damage):
	damage_txt_anim($Player.global_position,damage, $Player)
	player_hp -= damage
	lost_hp += damage

func player_damage(damage):
	damage_txt_anim($EnemyMarker.global_position,damage, creature)
	creature.animation_player.play("Damage")
	creature_hp -= damage

func damage_txt_anim(pos, amount, spot):
	var dmg_label = damage_label.instantiate()
	spot.add_child(dmg_label)
	dmg_label.global_position = pos
	dmg_label.text = str(int(amount))

func lost_pop_anim(pos,amount,spot):
	var popl = pop_lost.instantiate()
	spot.add_child(popl)
	popl.global_position = pos 
	popl.damage = str(int(amount))
	
func check_death():
	if lost_hp >= 100:
		lost_hp -=100
		level_manager.pop -= 1
		lost_pop_anim($Player.global_position - Vector2(0, 40), "-1", $Player)

func retreat():
	var path = path_scene.instantiate()
	is_combat_on = false
	path.retreat = true
	path.curve.clear_points()
	path.curve.add_point(island.global_position - global_position)
	path.curve.add_point(level_manager.last_island.global_position - global_position)
	if level_manager.last_island != null:
		path.to = level_manager.last_island
	path.from = island
	island.current_island = false
	island.add_child(path)
	island.has_encounter = true
	island.end_combat()
	island.create_creature_prop()
	queue_free()

func _on_button_pressed():
	retreat()
