extends CharacterBody3D

@export var LOOK_SENSITVITY = 0.1

@export var SPEED = 5.0
@export var SPRINT_SPEED = 10
@export var JUMP_VELOCITY = 10
@export var MAX_HEAD_TURN = 30.0
@export var WALL_RUN_CLOSENESS = 2.0
@export var WALL_RUN_MIN_SPEED = 6

@onready var head = $head
@onready var body = $body
@onready var wall_left_cast = $wallCastLeft
@onready var wall_right_cast = $wallCastRight

@onready var anim_tree = $body/AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
    for wall_cast in [wall_left_cast, wall_right_cast]:
        wall_cast.target_position.x *= WALL_RUN_CLOSENESS
    
func _input(event):

    #get mouse input for camera rotation
    if event is InputEventMouseMotion:
        rotate_y(deg_to_rad(-event.relative.x * LOOK_SENSITVITY))
        # head.rotation_degrees.y = clamp(head.rotation_degrees.y, -1 * MAX_HEAD_TURN, MAX_HEAD_TURN)
        # code for up/down look
        head.rotate_x(deg_to_rad(-event.relative.y * LOOK_SENSITVITY))
        head.rotation_degrees.x = clamp(head.rotation_degrees.x, -1 * MAX_HEAD_TURN, MAX_HEAD_TURN)

func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta


    var on_floor: bool = is_on_floor()
    var wall_running: bool = false
    # Handle Jump.
    
    if not on_floor and Vector2(velocity.x, velocity.z).length() > WALL_RUN_MIN_SPEED:
        for wall_cast in [wall_left_cast, wall_right_cast]:
            if wall_cast.is_colliding():
                wall_running = true
                print(fmod(wall_cast.target_position.x, 1))
                body.rotation_degrees.x = -20 * wall_cast.target_position.x
                if velocity.y <= 0:
                    velocity.y = 0

    if not wall_running:
        body.rotation_degrees.x = 0
    
    if Input.is_action_just_pressed("ui_accept") and (on_floor or wall_running):
        velocity.y = JUMP_VELOCITY


    # Handle sprinting.
    var speed = SPEED
    if Input.is_action_pressed("move_spr"):
        speed = SPRINT_SPEED

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir = Input.get_vector("move_lef", "move_rig", "move_for", "move_bac")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)

    if Vector2(velocity.x, velocity.z).length() > WALL_RUN_MIN_SPEED:
        pass

    if Vector2(velocity.x, velocity.z).length() > WALL_RUN_MIN_SPEED and (on_floor or wall_running):
        anim_tree.set("parameters/conditions/run", true)
        anim_tree.set("parameters/conditions/idle", false)
        anim_tree.set("parameters/conditions/walk", false)
    elif Vector2(velocity.x, velocity.z).length()  and (on_floor or wall_running):
        anim_tree.set("parameters/conditions/run", false)
        anim_tree.set("parameters/conditions/idle", false)
        anim_tree.set("parameters/conditions/walk", true)
    else:
        anim_tree.set("parameters/conditions/run", false)
        anim_tree.set("parameters/conditions/idle", true)
        anim_tree.set("parameters/conditions/walk", false)

    move_and_slide()
