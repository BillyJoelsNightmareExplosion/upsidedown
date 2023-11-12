extends PlayerState

var initial_xz_velocity : Vector2
var was_sprinting : bool

func enter(msg := {}):
	if (msg.has("do_jump")):
		player.velocity.y = player.JUMP_VELOCITY
		initial_xz_velocity = Vector2(player.velocity.x, player.velocity.z)
	was_sprinting = msg.has("was_sprinting")

func physics_update(delta):
	# different speed for adjusting in the air.	
	#if (Vector2(player.velocity.x - player.direction.x, player.velocity.z -player.direciton.y).length_squared() > player.AIR_MOD_SPEED^2):
	#	player.velocity.x = initial_xz_velocity.x + player.direction.x * player.AIR_MOD_SPEED
	#	player.velocity.z = initial_xz_velocity.y + player.direction.y * player.AIR_MOD_SPEED 
	#	player.apply_gravity(delta)
	var vec = calculate_xz_vector(Vector2(player.velocity.x, player.velocity.z), Vector2(player.direction.x, player.direction.z), delta)
	player.velocity.x = vec.x
	player.velocity.z = vec.y


	player.apply_gravity(delta)

	# Landing.
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")

func calculate_xz_vector(velocity : Vector2, input_dir : Vector2, delta) -> Vector2:
	var target := input_dir
	var delta_vec =  target * player.AIR_MOD_ACCELERATION * delta

	if was_sprinting:
		delta_vec *= player.SPRINT_JUMP_MODIFIER
	var max_vel = max(velocity.length(), player.AIR_MOD_SPEED)
	return (velocity + delta_vec).limit_length(max_vel)


