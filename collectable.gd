extends Node3D

var pickuppable = false
var elapsed_time = 0

@export var hoverSpeed = 3.1
@export var hoverRange = 5
@export var heightCorrection = 0.7

@onready var models = [
	$Area3D/MeshInstance3D,
	$Area3D/box,
	$Area3D/capsule,
	$Area3D/cylinder,
	$Area3D/plane,
	$Area3D/quad,
	$Area3D/prism,
	$Area3D/torus
]

# When the player touches the collectable, delete it and subtract the total number of collectables
func _on_area_3d_body_entered(body):
	if pickuppable:
		queue_free()
		GameManager.numPlaced -= 1

func is_player_touching_me() -> bool:
	return $Area3D.get_overlapping_bodies().size() != 0

func _process(delta):
	elapsed_time += delta
	$Area3D.position.y = sin(elapsed_time * hoverSpeed) / hoverRange + heightCorrection
