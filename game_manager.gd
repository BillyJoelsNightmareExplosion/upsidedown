extends Node

var obj = preload("res://collectable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Takes in position of the player, places the caller at that position
func place(position : Vector3):
	var placedCollectable = obj.instance()
	get_tree().get_root().get_node("main").add_child(placedCollectable)
	placedCollectable.global_position = position
