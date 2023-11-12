extends PlayerState

func enter(_msg := {}):
	player.anim_sm.travel("Walk")

func physics_update(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_to("Air", {do_jump = true})
	# Sprinting
	if Input.is_action_just_pressed("move_spr"):
		state_machine.transition_to("Sprint")
	#print("YOOO")
	player.align_model_with_movement(delta)
	# Movement ---------------------------
	if player.direction.is_equal_approx(Vector3.ZERO):
		state_machine.transition_to("Idle")
	else:
		player.velocity.x = player.direction.x * player.SPEED
		player.velocity.z = player.direction.z * player.SPEED
		player.velocity.y -= player.GRAVITY
