extends Node

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
	buffer_size = bytes.size()
	# not too sure which one to use here, but this seems good for now.
	var compressed_bytes = bytes.compress(FileAccess.COMPRESSION_DEFLATE) 
	var code = shuffle_string(compressed_bytes.hex_encode())
	return code

func decrypt_code(code : String):
	var bytes = shuffle_string(code).hex_decode()
	if (!buffer_size):
		printerr('Buffer Size not set, decompression failed.')
		return []
	var decompressed_bytes = bytes.decompress(buffer_size, FileAccess.COMPRESSION_DEFLATE)
	return (bytes_to_var(decompressed_bytes))


func shuffle_string(input : String) -> String:
	# shuffles characters in the string such that applying the shuffle twice
	# is equivalent to doing nothing.
	var output = input
	var i := 0
	while (i < output.length()):
		# if there are an odd number of characters, leave the last one alone.
		if i + 1 == output.length():
			break
		var temp = output[i] 
		output[i] = output[i + 1]
		output[i + 1] = temp
		i += 2
	return output


