extends PlayerState

func enter(_msg := {}):
	player.anim_sm.travel("Idle")
	#player.floor_stop_on_slope = true

func physics_update(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("move_jum"):
		player.floor_stop_on_slope = false
		state_machine.transition_to("Air", {do_jump = true})
		return
	# Movement ---------------------------
	elif player.direction:
		#player.floor_stop_on_slope = false
		if Input.is_action_pressed("move_spr"):
			state_machine.transition_to("Sprint")
			return
		else:
			state_machine.transition_to("Walk")
			return

	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	player.velocity.y -= player.GRAVITY * delta
