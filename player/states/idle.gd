extends PlayerState

func enter(_msg := {}):
	player.anim_sm.travel("Idle")
	#player.floor_stop_on_slope = true

func physics_update(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("move_jum"):
		#player.floor_stop_on_slope = false
		state_machine.transition_to("Air", {do_jump = true})
		return
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	# Movement ---------------------------
	if player.direction:
		#player.floor_stop_on_slope = false
		if Input.is_action_pressed("move_spr"):
			state_machine.transition_to("Sprint")
			return
		else:
			state_machine.transition_to("Walk")
			return

	var target_velocity = Vector2.ZERO
	player.apply_movement(target_velocity, delta)
	player.velocity.y -= player.GRAVITY * delta
