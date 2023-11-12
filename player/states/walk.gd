extends PlayerState

func enter(_msg := {}):
	player.anim_sm.travel("Walk")

func physics_update(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("move_jum"):
		state_machine.transition_to("Air", {jump_vector = Vector3.UP})
		return
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	# Sprinting
	elif Input.is_action_just_pressed("move_spr"):
		state_machine.transition_to("Sprint")
		return
	# Idle
	elif player.direction.is_equal_approx(Vector3.ZERO):
		state_machine.transition_to("Idle")
		return
	# Movement ---------------------------
	else:
		#player.velocity.x = player.direction.x * player.SPEED
		#player.velocity.z = player.direction.z * player.SPEED
		var xz_direction = Vector2(player.direction.x, player.direction.z)
		var target_velocity = xz_direction * player.WALK_SPEED
		player.apply_movement(target_velocity, delta)
		player.apply_gravity(delta)

	player.align_model_with_movement(delta)
