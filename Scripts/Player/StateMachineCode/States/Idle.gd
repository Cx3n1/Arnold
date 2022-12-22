extends PlayerState


export (NodePath) var _animation_player
onready var animation_player:AnimatedSprite = get_node(_animation_player)

func enter(_msg := {}):
	print("ent idle")
	
	if(player.is_facing_right):
		animation_player.play("Idle_right")
	else :
		animation_player.play("Idle_left")


func physics_update(delta: float):
	if !player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	#stop character (reduce velocity to 0)
	#player.velocity.x = lerp(player.velocity.x, 0, player.FRICTION_GROUND * delta)
	player.velocity.x = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	state_transition_logic()

func state_transition_logic():
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {jumped = true})
	elif Input.is_action_just_pressed("hide"):
		state_machine.transition_to("Hide")
	elif !is_zero_approx(player._get_input_direction()):
		state_machine.transition_to("Run")
	
	#do we need hooked condition??
