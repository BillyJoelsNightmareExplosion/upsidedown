extends PlayerState

func enter(_msg := {}):
		player.anim_sm.travel("Sprint")

func physics_update(delta):
	# Walking
	if Input.is_action_just_released("move_spr"):
		state_machine.transition_to("Walk")
		return
	# Handle Jump.
	if Input.is_action_just_pressed("move_jum"):
		state_machine.transition_to("Air", {jump_vector = Vector3.UP, was_sprinting = true})
		return
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	if player.direction.is_equal_approx(Vector3.ZERO):
		state_machine.transition_to("Idle")
		return
	# Movement -------------------------------------------------------------------------------
	else:
		#player.velocity.x = player.direction.x * player.SPRINT_SPEED
		#player.velocity.z = player.direction.z * player.SPRINT_SPEED
		var xz_direction = Vector2(player.direction.x, player.direction.z)
		var target_velocity = xz_direction * player.SPRINT_SPEED
		player.apply_movement(target_velocity, delta)
		player.apply_gravity(delta)
		
		if player.stream_player.stream == player.s_walk:
			player.stream_player.stop()
		
		if not player.stream_player.is_playing():
			player.stream_player.stream = player.s_run
			player.stream_player.play()

	player.align_model_with_movement(delta)
