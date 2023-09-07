extends StaticBody2D

var health: float = 11
var min_dmg: int  = 1
var max_dmg: int = 5

var parent: Node 
var in_combat: bool = false

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Idle")
	
func animation_end():
	get_parent().creature_attack()
