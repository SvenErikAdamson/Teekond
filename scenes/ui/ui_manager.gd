extends CanvasLayer

@onready var pop_label = $Control/MarginContainer/VBoxContainer/Amount/FoodLabel
@onready var food_label =$Control/MarginContainer/VBoxContainer/Amount/FoodLabel
@onready var water_label = $Control/MarginContainer/VBoxContainer/Amount/WaterLabel
@onready var node_manager = get_node("/root/Game/Level")

func _process(_delta):
	pop_label.text = str(node_manager.pop)
	food_label.text = str(node_manager.food)
	water_label.text = str(node_manager.water)