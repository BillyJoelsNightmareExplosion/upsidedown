extends Control


@onready var vector_line2D: Line2D = $VectorDisplay/Center/Line2D
@onready var float_line2D: Line2D = $FloatDisplay/Center/Line2D

var display_vector : Vector2
var display_float := 0.0

@export var display_float_max = 20

func _process(_delta):
	vector_line2D.points = PackedVector2Array([Vector2.ZERO, display_vector * 40])
	float_line2D.points = PackedVector2Array([Vector2.ZERO, Vector2(0, -display_float * 80 / display_float_max)])

