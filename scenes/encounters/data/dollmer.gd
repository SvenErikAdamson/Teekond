extends StaticBody2D

var health: float = 30
var min_dmg: int  = 0
var max_dmg: int = 5

var parent: Node 
var in_combat: bool = false

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Idle")
	
func animation_end():
	get_parent().encounter_attack()

func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("mb_left") and in_combat:
		pass
