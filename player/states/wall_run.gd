extends PlayerState


# this is all horrible code, i started to panic about deadlines. sorruy.

var entrance_direction : Vector3
var wall_side : String
var wall_normal : Vector3
var travel_direction : Vector3
var current_collider : RayCast3D
var has_collided_recently = true
	

func enter(_msg := {}):
		player.anim_sm.travel("Sprint")
		entrance_direction = _msg["entrance_direction"]
		wall_side = _msg["wall_side"]
		wall_normal = _msg["wall_normal"]

		if wall_side == "left":
			current_collider = player.wall_left_cast
		else:
			current_collider = player.wall_right_cast


func physics_update(delta):
	
	if current_collider.is_colliding():
		has_collided_recently = true
	else:
		has_collided_recently = false
		delayed_collider_check()
	if (Input.is_action_just_pressed("move_jum")):
		#print("jump press")
		calculate_launch_vector()
		state_machine.transition_to("Air", {
			jump_vector = calculate_launch_vector(),
			was_sprinting = true
			})
		return
	#if player.direction.dot(wall_normal) > 0 or player.input_dir == Vector2.ZERO:
		#print("dot")
		#state_machine.transition_to("Air", {do_jump = false})
		#return
	if player.is_on_floor():
		state_machine.transition_to("Sprint")
		return

	set_travel_direction()
	player.velocity = travel_direction * player.SPRINT_SPEED
	
func set_travel_direction():
	wall_normal = current_collider.get_collision_normal()
	var sign = 1.0 if wall_side == "left" else -1.0
	travel_direction = wall_normal.rotated(Vector3.UP, sign * PI/2)
	player.body.rotation_degrees.z = -20 * sign
	travel_direction.y = 0
	travel_direction = travel_direction.normalized()

func delayed_collider_check():
	await get_tree().create_timer(0.2).timeout
	if state_machine.state == self and not has_collided_recently:
		#print("miss")
		state_machine.transition_to("Air", {})


func calculate_launch_vector():
	if (Input.is_action_pressed("move_rig") and wall_side == "left"):
			return (wall_normal + Vector3.UP).normalized()
	elif (Input.is_action_pressed("move_lef") and wall_side == "right"):
		return (wall_normal + Vector3.UP).normalized()
	return (wall_normal * 2 + Vector3.UP).normalized()
