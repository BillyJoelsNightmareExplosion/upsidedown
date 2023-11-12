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
	player.velocity.x = vec.x
	player.velocity.z = vec.y

	player.apply_gravity(delta)
	player.align_model_with_xz_velocity(delta)

	# Landing check
	if player.is_on_floor():
		#player.anim_tree.active = true
		if player.velocity.is_equal_approx(Vector3.ZERO):
			state_machine.transition_to("Idle")
			return
		elif Input.is_action_pressed("move_spr"):
			state_machine.transition_to("Sprint")
			return
		else:
			state_machine.transition_to("Walk")
			return



# This function calculates an xz_vector as air movement is a lot more complicated than ground.
func calculate_xz_vector(velocity : Vector2, input_dir : Vector2, delta) -> Vector2:
	var target := input_dir
	var delta_vec =  target * player.AIR_MOD_ACCELERATION * delta

	if was_sprinting:
		delta_vec *= player.SPRINT_JUMP_MODIFIER
	var max_vel = max(velocity.length(), player.AIR_MOD_SPEED)
	return (velocity + delta_vec).limit_length(max_vel)


