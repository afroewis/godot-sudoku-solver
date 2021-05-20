extends Control

export(PackedScene) var rect_scene = preload("res://number.tscn")

onready var button = get_node("Button")
onready var container = get_node("GridContainer")

# Game state

var board = [
	0, 0, 0, 0, 1, 0, 0, 0, 2,
	0, 0, 0, 0, 0, 3, 0, 1, 0,
	0, 0, 4, 0, 0, 5, 0, 0, 6,
	0, 0, 0, 6, 0, 0, 7, 5, 0,
	0, 0, 1, 0, 0, 0, 8, 0, 0,
	0, 8, 3, 0, 0, 9, 0, 0, 0,
	8, 0, 0, 7, 0, 0, 9, 0, 0,
	0, 2, 0, 5, 0, 0, 0, 0, 0,
	7, 0, 0, 0, 4, 0, 0, 0, 0
]

var rows: Array = []
var cols: Array = []
var cells: Array = []

func _ready():
	button.connect("button_down", self, "solve_pressed")
	create_board()

func solve_pressed():
	var number = container.get_children()[0]
	var label: Label = number.get_node("Label")
	label.text = String("Hi")
	
func create_board():
	for x in board:
		var instance = rect_scene.instance()
		var label = instance.get_node("Label")
		
		if x != 0:
			label.text = String(x)
		
		container.add_child(instance)
		
		for i in 9:
			rows.append(Bitset.new(9))
			cols.append(Bitset.new(9))
			cells.append(Bitset.new(9))
			
		for i in board.size():
			var row: int = GetRow(i)
			var column: int = GetColumn(i)
			var cell: int = GetCell(i)

			var v = board[i]

			if v != 0:
				rows[row].set_bit(v - 1, true)
				cols[column].set_bit(v - 1, true)
				cells[cell].set_bit(v - 1, true)
			else:
				print("hi")
				

func GetRow(index: int) -> int:
	return index / 9;

func GetColumn(index: int) -> int:
	return index % 9;

func GetCell(index: int) -> int:
	return (GetRow(index) / 3) * 3  + GetColumn(index) / 3;
