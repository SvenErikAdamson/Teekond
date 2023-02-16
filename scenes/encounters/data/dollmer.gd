extends Node2D

var health: float = 30
var min_dmg: int  = 0
var max_dmg: int = 5

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Idle")
	
func animation_end():
	get_parent().encounter_attack()
