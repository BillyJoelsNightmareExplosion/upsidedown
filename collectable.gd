extends Node3D

var pickuppable = false

func _on_area_3d_body_entered(body):
	print("balls")
	if pickuppable:
		queue_free()

func is_player_touching_me() -> bool:
	return $Area3D.get_overlapping_bodies().size() != 0
