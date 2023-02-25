extends StaticBody2D

var health: float = 64
var min_dmg: int  = 94
var max_dmg: int = 231

var parent: Node 
var in_combat: bool = false

@onready var animation_player = $AnimationPlayer

signal on_click_damage()


func _ready():
	animation_player.play("Idle")
	
func animation_end():
	get_parent().creature_attack()

func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("mb_left") and in_combat:
		print("damage")
		on_click_damage.emit()


