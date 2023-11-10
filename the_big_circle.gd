@tool
extends Path3D

var t = 12
@export_range(0, 1, 0.01) var wheee = 0.1

func _process(delta):
	var follow_nodes = get_children()
	for i in range(0, follow_nodes.size()):
		#follow_nodes[i].progress_ratio = (float(i) / follow_nodes.size()) + time
		follow_nodes[i].progress_ratio += delta * wheee
		
