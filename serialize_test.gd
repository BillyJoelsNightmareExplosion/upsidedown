extends Node

func _ready():
	var positions = []
	for child in get_children():
		positions.append(child.global_position)
	print("position array:")
	print(positions)
	print('serialized field:')
	var byte_string = var_to_bytes(positions).hex_encode()
	print(byte_string)
	print('deserialized field:')
	print((byte_string.hex_decode()))
