extends Node2D

var height = 10
var width = 10

@onready var map = $TileMap

func _ready():
	randomize()
	generate_maze()

func generate_maze():
	var stack = []
	for x in range(width):
		for y in range(height):
			map.set_cell(0, Vector2i(x, y), 0, Vector2i(3, 3), 0)

