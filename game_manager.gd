extends Node

var obj = preload("res://collectable.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("place_pickup"):
		place(get_tree().get_root().get_node("main/player").global_position)

# Takes in position of the player, places the caller at that position
func place(position : Vector3):
	var placedCollectable = obj.instantiate()
	get_tree().get_root().get_node("main").add_child(placedCollectable)
	placedCollectable.global_position = position
	await placedCollectable.get_node("Area3D").body_exited
	placedCollectable.pickuppable = true
