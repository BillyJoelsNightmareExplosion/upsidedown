extends PlayerState

func enter(_msg := {}):
	player.anim_sm.travel("Walk")

func physics_update(_delta):
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_to("Air", {do_jump = true})
	# Sprinting
	if Input.is_action_just_pressed("move_spr"):
		state_machine.transition_to("Sprint")
	
	# Movement ---------------------------
	if owner.direction.is_equal_approx(Vector3.ZERO):
		state_machine.transition_to("Idle")
	else:
		owner.velocity.x = owner.direction.x * owner.SPEED
		owner.velocity.z = owner.direction.z * owner.SPEED
		#owner.velocity.y -= owner.GRAVITY
