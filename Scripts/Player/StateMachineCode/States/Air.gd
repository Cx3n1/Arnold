extends PlayerState


export (NodePath) var _animation_player
onready var animation_player:AnimatedSprite = get_node(_animation_player)


func enter(_msg := {}):
	print("ent air")
	if(!_msg.has("jumped")): return

	if(player.jump_count == 1):
		if(player.is_facing_right):
			animation_player.play("Double Jump_right")
		else :
			animation_player.play("Double Jump_left")
			
		player.velocity.y = -player.JUMP_FORCE
		player.jump_count -= 1
		
		return
	
	if(player.jump_count == 2):
		if(player.is_facing_right):
			animation_player.play("Jump_up_right")
		else:
			animation_player.play("Jump_up_left")
			
		player.velocity.y = -player.JUMP_FORCE
		player.jump_count -= 1
		
	elif(player.is_facing_right):
		animation_player.play("In_air_right")
	else:
		animation_player.play("In_air_left")


func physics_update(delta: float):
	if(!is_zero_approx(player._get_input_direction())):
		#player.velocity.x = lerp(player.velocity.x, player._get_input_direction()*player.MOVE_SPEED, player.MOVE_ACCEL * delta)
		player.velocity.x += player._get_input_direction()*player.MOVE_SPEED
	else:
		#player.velocity.x = lerp(player.velocity.x, 0, player.FRICTION_AIR * delta)
		player.velocity.x = 0
	
	
	player.velocity.y += player.GRAVITY
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)	# Actually apply all the forces
	
	
	if(!is_zero_approx(player._get_input_direction())):
		player.velocity.x -= player._get_input_direction()*player.MOVE_SPEED
	
	state_transition_logic()


func state_transition_logic():
	print(player.is_on_floor())
	if player.is_on_floor():
		if is_zero_approx(player._get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
		player.jump_count = player.AIR_JUMP_AMOUNT
		print("Exited Air")
		#state_machine.transition_to("Land")
		
	elif Input.is_action_just_pressed("jump") && player.jump_count != 0:
		state_machine.transition_to("Air", {jumped = true})
		print("Entered air jump")
