extends Control

export(PackedScene) var rect_scene = preload("res://color_rect.tscn")

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
	var board = [3, 2, 1]
	
	for x in board:
		var instance = rect_scene.instance()
		var label = instance.get_node("Label")
		label.text = String(x)
		
		container.add_child(instance)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
