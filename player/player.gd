class_name Player
extends CharacterBody3D

@export var LOOK_SENSITVITY = 0.1
@export_category("Movement Paramaters")
@export var SPEED = 5.0
@export var SPRINT_SPEED = 10
@export var AIR_MOD_SPEED = 3.0
@export var AIR_MOD_ACCELERATION = 5.0
@export_range(0.0, 1.0, 0.05) var SPRINT_JUMP_MODIFIER = 0.0 # If set to 0, player can't modify their course if they sprint jump)
@export var JUMP_VELOCITY = 10
@export var MAX_HEAD_TURN = 30.0
@export var WALL_RUN_CLOSENESS = 2.0
@export var WALL_RUN_MIN_SPEED = 6

@onready var head = $Head
@onready var body = $Body
@onready var wall_left_cast = $WallCastLeft
@onready var wall_right_cast = $WallCastRight

@onready var anim_tree = $Body/AnimationTree
@onready var anim_sm = $Body/AnimationTree["parameters/playback"]

var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_dir
var direction

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * LOOK_SENSITVITY))
		# head.rotation_degrees.y = clamp(head.rotation_degrees.y, -1 * MAX_HEAD_TURN, MAX_HEAD_TURN)
		# code for up/down look
		head.rotate_x(deg_to_rad(-event.relative.y * LOOK_SENSITVITY))
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -1 * MAX_HEAD_TURN, MAX_HEAD_TURN)

func _physics_process(_delta):
	input_dir = Input.get_vector("move_lef", "move_rig", "move_for", "move_bac")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	move_and_slide()

func make_model_face_input_dir():
	body.transform.basis = Vector3(direction.x, 1, direction.z)

func apply_gravity(delta):
	velocity.y -= GRAVITY * delta
