extends Node2D

@onready var pointer = $Pointer
var speed
var maxs = 180.0
var mins = -180.0
var distance = 0.0

var difficulty: float 
var health: float 
var health_lost: float
var tries: int = 5
var island = get_parent()

@onready var animation_player = $AnimationPlayer
@onready var level_manager = get_node("/root/Game/Level")

var is_lapping: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("RESET")
	randomize()
	health_lost = 0
	health = level_manager.pop * 100
	difficulty = level_manager.pop / 2
	speed = randf_range(40,160)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and is_lapping:
		difficulty -= 1.0
		print(difficulty)
		animation_player.play("Right")
		tries -= 1
		
	if Input.is_action_just_pressed("interact") and !is_lapping:
		animation_player.play("Wrong")
		health -= 20
		health_lost +=20
		tries -=1

	if health_lost >= 100:
		health_lost = 0.0
		level_manager.pop -= 1
	if tries <= 0:
		get_parent().is_in_minigame = false
		get_parent().minigame_scene = null
		queue_free()
		
	pointer.position.x += speed * delta
	if pointer.position.x >= 38.0:
		speed = -randf_range(80, 350)
	if  pointer.position.x <= -38.0:
		speed = randf_range(80, 350)
	if difficulty <= 0:
		island.is_in_minigame = false
		island.minigame_scene = null
		queue_free()

func _on_area_2d_area_entered(_area):
	is_lapping = true

func return_back():
	animation_player.play("RESET")

func _on_area_2d_area_exited(_area):
	is_lapping = false

