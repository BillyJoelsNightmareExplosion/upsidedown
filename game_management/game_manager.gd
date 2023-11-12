extends Node

var MAX_COLLECTABLES = 8

var numPlaced = 0
var mode = null
var generated_code = ""
var inputted_code = ""

var end_screen_scene = preload("res://addons/EasyMenus/Scenes/end_screen.tscn")
var collectable_scene = preload("res://collectable.tscn")
var text_display = preload("res://game_management/victory_message.tscn")
var text_display_node : Control # this is stupid

# if the player is placing a collectable, place it at the player's position and update the count
func _process(delta):
	if mode == "hide":
		process_hide_mode()
	else:
		process_find_mode()


func process_hide_mode():
	if Input.is_action_just_pressed("place_pickup"):
		if numPlaced < MAX_COLLECTABLES:
			# place collectible!
			place(get_tree().get_root().get_node("main/player").global_position)
		if numPlaced == MAX_COLLECTABLES:
			# display victory text
			text_display_node = text_display.instantiate()
			generated_code = Serializer.generate_code(get_positions_of_placed_items())
			DisplayServer.clipboard_set(GameManager.generated_code)
			DisplayServer.clipboard_set(Serializer.generate_code(get_positions_of_placed_items()))
			print("")
			print(get_positions_of_placed_items())
			print(generated_code)
			add_child(text_display_node)
	
	if Input.is_action_just_pressed("enter"):
		if numPlaced == MAX_COLLECTABLES:
			# progress to end screen
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			text_display_node.queue_free()
			generated_code = inputted_code
			MenuTemplateManager.switch_scene(end_screen_scene)

func process_find_mode():
	if Input.is_action_just_pressed("enter"):
		if numPlaced == 0:
			# progress to end screen
			text_display_node.queue_free()

			MenuTemplateManager.switch_scene(end_screen_scene)
			get_tree().root.get_node("main").queue_free()

# Takes in position of the player, places the collectable at that position
func place(position : Vector3):
	numPlaced += 1
	var placedCollectable = collectable_scene.instantiate()
	get_tree().get_root().get_node("main").add_child(placedCollectable)
	placedCollectable.global_position = position
	placedCollectable.add_to_group("collectables")
	
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


func get_positions_of_placed_items() -> Array:
	var positions = []
	for node in get_tree().get_nodes_in_group("collectables"):
		positions.append(node.global_position)
	return positions


func place_items_for_player_to_find():
	var positions = Serializer.decrypt_code(inputted_code)
	for i in range(positions.size()):
		var newNode = collectable_scene.instantiate()
		add_child(newNode)
		newNode.global_position = positions[i]
		newNode.models[i].visible = true
		newNode.pickuppable = true
		
