extends PlayerState

var initial_xz_velocity : Vector2
var was_sprinting : bool

func enter(msg := {}):
	if (msg.has("do_jump")):
		player.velocity.y = player.JUMP_VELOCITY
		initial_xz_velocity = Vector2(player.velocity.x, player.velocity.z)
	was_sprinting = msg.has("was_sprinting")
	#player.anim_tree.active = false

func physics_update(delta):
	
	var vec = calculate_xz_vector(Vector2(player.velocity.x, player.velocity.z), Vector2(player.direction.x, player.direction.z), delta)
	var transitioned: bool
	transitioned = landing_check()
	if transitioned:
		return
	
	# Wall run check
	transitioned = wall_run_check()
	if transitioned:
		return
	
	player.velocity.x = vec.x
	player.velocity.z = vec.y
	player.apply_gravity(delta)
	player.align_model_with_xz_velocity(delta)

	

func landing_check() -> bool:
	# Landing check
	if player.is_on_floor():
		#player.anim_tree.active = true
		if player.velocity.is_equal_approx(Vector3.ZERO):
			state_machine.transition_to("Idle")
			return true
		elif is_equal_approx(player.velocity.y, 0): # this one caused an infinite loop :D 
			if Input.is_action_pressed("move_spr"):
				state_machine.transition_to("Sprint")
				return true
			else:
				state_machine.transition_to("Walk")
				return true
	return false

func wall_run_check() -> bool:
	var altitude = min(player.velocity.angle_to(Vector3.UP), player.velocity.angle_to(Vector3.DOWN))
	if altitude > deg_to_rad(60):
		return false
	if not was_sprinting:
		return false
	if Input.is_action_just_pressed("move_jum"): # infinite loop catch
		return false

	var left_collide = player.wall_left_cast.is_colliding()
	var right_collide = player.wall_right_cast.is_colliding()
	var hit : RayCast3D
	var side : String
	if left_collide:
		side = "left"
		hit = player.wall_left_cast
	if right_collide:
		side = "right"
		hit = player.wall_right_cast

	if (left_collide or right_collide) and was_sprinting:
		state_machine.transition_to("WallRun", {
			wall_side = side,
			entrance_direction = player.velocity,
			wall_normal = hit.get_collision_normal()
		})
		return true
	return false


# This function calculates an xz_vector as air movement is a lot more complicated than ground.
func calculate_xz_vector(velocity : Vector2, input_dir : Vector2, delta) -> Vector2:
	var target := input_dir
	var delta_vec =  target * player.AIR_CORRECTION_ACCELERATION * delta

	if was_sprinting:
		delta_vec *= player.SPRINT_JUMP_CORRECTION_MOD
	var max_vel = max(velocity.length(), player.AIR_CORRECTION_SPEED)
	return (velocity + delta_vec).limit_length(max_vel)


