extends PlayerState

func enter(_msg := {}):
	player.anim_sm.travel("Idle")

func physics_update(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("move_jum"):
		state_machine.transition_to("Air", {do_jump = true})
	# Movement ---------------------------
	if player.direction:
		if Input.is_action_pressed("move_spr"):
			state_machine.transition_to("Sprint")
		else:
			state_machine.transition_to("Walk")

	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	player.velocity.y -= player.GRAVITY * delta
