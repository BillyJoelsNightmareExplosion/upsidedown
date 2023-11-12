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

	if owner.direction.is_equal_approx(Vector3.ZERO):
		state_machine.transition_to("Idle")
	else:
		player.velocity.x = owner.direction.x * owner.SPRINT_SPEED
		player.velocity.z = owner.direction.z * owner.SPRINT_SPEED
		player.velocity.y -= player.GRAVITY * delta
