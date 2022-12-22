extends PlayerState

export (NodePath) var _animation_player
onready var animation_player:AnimatedSprite = get_node(_animation_player)

export (NodePath) var _right_run_particles
onready var right_run_particles:Particles2D = get_node(_right_run_particles)

export (NodePath) var _left_run_particles
onready var left_run_particles:Particles2D = get_node(_right_run_particles)

func enter(_msg := {}):
	#print("ent run")
	
	if(player.is_facing_right):
		animation_player.play("Running_right")
		right_run_particles.emitting = true
	else :
		animation_player.play("Running_left")
		left_run_particles.emitting = true

func physics_update(delta: float):
	if !player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if(!is_zero_approx(player._get_input_direction())):
		#player.velocity.x = lerp(player.velocity.x, player._get_input_direction()*player.MOVE_SPEED, player.MOVE_ACCEL * delta)
		player.velocity.x += player._get_input_direction()*player.MOVE_SPEED
	
	player.velocity.y += player.GRAVITY
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)	# Actually apply all the forces
	
	player.velocity.x -= player._get_input_direction()*player.MOVE_SPEED
	
	state_transition_logic()


func state_transition_logic():
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {jumped = true})
		stop_particle_emission()
	elif Input.is_action_just_pressed("hide"):
		state_machine.transition_to("Hide")
		stop_particle_emission()
	elif is_zero_approx(player._get_input_direction()):
		state_machine.transition_to("Idle")
		stop_particle_emission()


func stop_particle_emission():
	right_run_particles.emitting = false
	left_run_particles.emitting = false
	
