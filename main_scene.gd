extends Control

export(PackedScene) var rect_scene = preload("res://number.tscn")

onready var button = get_node("Button")
onready var container = get_node("GridContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("button_down", self, "on_pressed")
	set_up()
	

func on_pressed():
	var instance = rect_scene.instance()
	container.add_child(instance)
	
func set_up():
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
	
	for x in board:
		var instance = rect_scene.instance();
		var label = instance.get_node("Label");
		
		if [x == 0]:
			label.text = String(x)
		
		container.add_child(instance)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
