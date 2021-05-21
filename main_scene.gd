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
var steps: Array = []

func are_all_true(arr: Array) -> bool:
	for i in arr.size():
		if arr[i] == false:
			return false
	return true

func _ready():
	button.connect("button_down", self, "solve_pressed")
	create_board()

func solve_pressed():
	print_board()
	solve(board, 0, rows, cols, cells)
	print_board()
	
	for i in steps:
		var index = i[0]
		var value = i[1]
		var number = container.get_children()[index]
		var label: Label = number.get_node("Label")
		var text = String(" ") if value == 0 else String(value)
		label.text = text
		yield(get_tree().create_timer(0.5), "timeout")
	
func create_board():	
	for x in board:
		var instance = rect_scene.instance()
		var label = instance.get_node("Label")
		
		if x != 0:
			label.text = String(x)
		
		container.add_child(instance)
			
	for i in board.size():
		var row: int = get_row(i)
		var column: int = get_column(i)
		var cell: int = get_cell(i)

		var v = board[i]

		for f in 9:
			rows.append([false, false, false, false, false, false, false, false, false])
			cols.append([false, false, false, false, false, false, false, false, false])
			cells.append([false, false, false, false, false, false, false, false, false])

		if v != 0:
			rows[row][v - 1] = true
			cols[column][v - 1] = true
			cells[cell][v - 1] = true
				
				
func solve(board: Array, currentIndex: int, rowValues: Array, columnValues: Array, cellValues: Array) -> bool:
	if currentIndex == 9 * 9:
		return true

	while board[currentIndex] != 0:
		currentIndex += 1

	var row: int = get_row(currentIndex)
	var column: int = get_column(currentIndex)
	var cell: int = get_cell(currentIndex)
	
	var usedValues: Array = [false, false, false, false, false, false, false, false, false]
	
	for i in 9:
		if rowValues[row][i] == true:
			usedValues[i] = true
		if columnValues[column][i] == true:
			usedValues[i] = true
		if cellValues[cell][i] == true:
			usedValues[i] = true

	if are_all_true(usedValues):
		return false
	
	for i in 9:
		var isUsed = usedValues[i]
		
		if !isUsed:
			board[currentIndex] = i + 1;
			add_step(currentIndex, i + 1)
			rowValues[row][i] = true
			columnValues[column][i] = true
			cellValues[cell][i] = true
			
			if solve(board, currentIndex + 1, rowValues, columnValues, cellValues):
				# Sudoku was solved.
				return true;
				
			rowValues[row][i] = false
			columnValues[column][i] = false
			cellValues[cell][i] = false
	
	# No number between 1-9 can be used. This path does not work.
	board[currentIndex] = 0;
	add_step(currentIndex, 0)
	return false

func add_step(index: int, newValue: int) -> void:
	steps.append([index, newValue])

func get_row(index: int) -> int:
	return index / 9;

func get_column(index: int) -> int:
	return index % 9;

func get_cell(index: int) -> int:
	return (get_row(index) / 3) * 3  + get_column(index) / 3;
	
func print_board():
	var strr = ""
	
	for i in 81:
		if (i % 9 == 0):
			strr += "\n"
		
		strr += String(board[i]) + " "
		
	print(strr)
