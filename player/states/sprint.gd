extends PlayerState

func enter(_msg := {}):
		player.anim_sm.travel("Sprint")

func physics_update(delta):
	
	# Walking
	if Input.is_action_just_released("move_spr"):
		state_machine.transition_to("Walk")
	# Handle Jump.
	if Input.is_action_just_pressed("move_jum"):
		state_machine.transition_to("Air", {do_jump = true, was_sprinting = true})
	
	# Movement -------------------------------------------------------------------------------
	player.align_model_with_movement(delta)

	if player.direction.is_equal_approx(Vector3.ZERO):
		state_machine.transition_to("Idle")
	else:
		player.velocity.x = player.direction.x * player.SPRINT_SPEED
		player.velocity.z = player.direction.z * player.SPRINT_SPEED
		player.apply_gravity(delta)
