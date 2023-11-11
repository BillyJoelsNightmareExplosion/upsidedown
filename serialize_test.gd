extends Node

#func _ready():
#	var positions = []
#	for child in get_children():
#		positions.append(child.global_position)
#	print("position array:")
#	print(positions)
#	print('serialized field:')
#	var code = generate_code(positions)
#	var byte_string = var_to_bytes(positions).hex_encode()
#	print(byte_string)
#	print('deserialized field:')
#	print((byte_string.hex_decode()))

var buffer_size : int # size of the uncompressed bite array, needed for decompression.
# depends on the number of objects we want to encode, so it's calculated before compression

func _ready():
	var positions : Array[Vector3] = []
	for child in get_children():
		positions.append(child.global_position)
	var code = generate_code(positions)
	var new_positions = decrypt_code(code)
	var equality_check = new_positions == positions
	
	print("Position array:\n", positions)
	print("\nHex Code: ", code)
	print("\nPositions from code:\n", new_positions)
	print("\nEqual?: ", equality_check)
	print("Size ratio: %s characters per object." % (code.length() / positions.size()))



func generate_code(positions : Array[Vector3]) -> String:
	var bytes = var_to_bytes(positions)
	# not too sure which one to use here, but this seems good for now.
	buffer_size = bytes.size()
	bytes = bytes.compress(FileAccess.COMPRESSION_DEFLATE) 
	return bytes.hex_encode()

func decrypt_code(code : String) -> Array:
	var bytes = code.hex_decode()
	if (!buffer_size):
		printerr('Buffer Size not set, decompression failed.')
		return []
	bytes = bytes.decompress(buffer_size, FileAccess.COMPRESSION_DEFLATE)
	return (bytes_to_var(bytes) as Array[Vector3])
