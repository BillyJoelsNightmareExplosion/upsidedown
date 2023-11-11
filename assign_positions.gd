extends Node


var packed_scene : PackedScene


func place_node(positions: Array[Vector3]) -> void:
	for i in range(positions.size()):
		var newNode = packed_scene.instance()
		newNode.global_position = positions[i]
		add_child(newNode)
