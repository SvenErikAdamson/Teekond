extends Node2D
var wall = Vector2i(3,3)
var empty = Vector2i(1,3)
var cell = Vector2i(2,3)
var height = 20
var width = 20

@onready var map = $TileMap

var cell_walls = [Vector2(0, -1), Vector2(1, 0),Vector2(0, 1), Vector2(-1, 0)]

func _ready():
	randomize()
	generate_maze()
	
		
func generate_maze():
	var unvisited = []
	var stack = []
	map.clear()
	
	for x in range(height):
		for y in range(width):
			unvisited.append(Vector2(x,y))
			map.set_cell(0,Vector2(x,y),0,wall,0)
	
	var start_x = 1 + randi_range(0, height)
	var start_y = 1 + randi_range(0, width)
	var current = Vector2i(start_x, start_y)
	
	while stack:
		var neighbours = check_neighbours(current)
		if neighbours.size() > 0:
			var next = neighbours[randi() % neighbours.size()]
			connect_cells(current,next)
			current = next
			stack.append(current)
		elif stack:
			current = stack.pop_back()
	

func check_neighbours(cell):
	var list = []
	if width > 0:
		list.pus
	
	return list

func connect_cells(from, to):
	var from_x = from.x if from.x <= to.x else to.x
	var to_x = to.x if from.x <= to.x else from.x
	var from_y = from.y if from.y <= to.y else to.y
	var to_y = to.y if from.y <= to.y else from.y
	for x in range(from_x, to_x + 1):
		for y in range(from_y, to_y + 1):
			map.set_cell(0,Vector2(x,y),0,empty,0)
