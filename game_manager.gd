extends Node

var MAX_COLLECTABLES = 8

var obj = preload("res://collectable.tscn")

var numPlaced = 0




# if the player is placing a collectable, place it at the player's position and update the count
func _process(delta):
	if Input.is_action_just_pressed("place_pickup"):
		if numPlaced < MAX_COLLECTABLES:
			place(get_tree().get_root().get_node("main/player").global_position)

# Takes in position of the player, places the collectable at that position
func place(position : Vector3):
	numPlaced += 1
	var placedCollectable = obj.instantiate()
	get_tree().get_root().get_node("main").add_child(placedCollectable)
	placedCollectable.global_position = position
	
	# todo: fix so that it shows the lowest index of the models array and hides the rest
	#var min
	#for i in range(0, 8):
		#if placedCollectable.models[i].visible == false:
		#	placedCollectable.models[i].visible = true
		#else:
		#	placedCollectable.models[i].visible = false
	for i in range(0, 8):
		placedCollectable.models[i].visible = (i == numPlaced - 1)
	
	await placedCollectable.get_node("Area3D").body_exited
	placedCollectable.pickuppable = true
