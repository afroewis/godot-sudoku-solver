extends Control

export(PackedScene) var rect_scene = preload("res://number.tscn")

onready var play_button = get_node("play_button")
onready var pause_button = get_node("pause_button")
onready var reset_button = get_node("reset_button")
onready var container = get_node("numbers_container")
onready var speed_slider = get_node("speed_slider")
onready var steps_label = get_node("steps_label")

# Game state
var new_board = [
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

var board = [] + new_board

var rows: Array = []
var cols: Array = []
var cells: Array = []
var steps: Array = []
var is_paused: bool
var current_step: int = 0
var speed: int = 0
var is_finished: bool = false

func _ready():
	play_button.connect("button_up", self, "solve_pressed")
	pause_button.connect("button_up", self, "pause_pressed")
	reset_button.connect("button_up", self, "reset_pressed")
	speed_slider.connect("value_changed", self, "speed_slider_value_changed")
	speed = 1 / speed_slider.value
	
	create_board()
	
	print_board()
	solve(board, 0, rows, cols, cells)
	update_steps(0, steps.size())
	print_board()
	
func speed_slider_value_changed(value: int) -> void:
	speed = 1 / value

func pause_pressed():
	play_button.disabled = false
	pause_button.disabled = true
	reset_button.disabled = false
	is_paused = true
	
func reset_pressed():
	play_button.disabled = false
	pause_button.disabled = true
	reset_button.disabled = true
	board = [] + new_board;
	steps = []
	rows = []
	cols = []
	cells = []
	is_paused = false
	is_finished = false
	current_step = 0	
	create_board()
	solve(board, 0, rows, cols, cells)
	update_steps(0, steps.size())
	
func solve_pressed():
	is_paused = false
	play_button.disabled = true
	pause_button.disabled = false
	reset_button.disabled = false
	
	while !is_paused && !is_finished:
		if current_step == steps.size():
			is_finished = true
			break
			
		var index = steps[current_step][0]
		var value = steps[current_step][1]
		var number = container.get_children()[index]
		var label: Label = number.get_node("Label")
		var text = String(" ") if value == 0 else String(value)
		label.text = text
		current_step += 1
		
		update_steps(current_step, steps.size())
		
		yield(get_tree().create_timer(speed), "timeout")

	
func create_board():
	for n in container.get_children():
		container.remove_child(n)
		
	for x in board:
		var instance = rect_scene.instance()
		var label = instance.get_node("Label")
		
		if x != 0:
			label.text = String(x)
			instance.color = Color.darkslateblue
		
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
	
func are_all_true(arr: Array) -> bool:
	for i in arr.size():
		if arr[i] == false:
			return false
	return true
	
func update_steps(executed: int, total: int) -> void:
	steps_label.text = str("Steps: ", executed, "/", total)
	
func print_board() -> void:
	var strr = ""
	
	for i in 81:
		if (i % 9 == 0):
			strr += "\n"
		
		strr += String(board[i]) + " "
		
	print(strr)
