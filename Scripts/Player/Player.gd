class_name Player
extends KinematicBody2D



const JUMP_FORCE = 1000			# Force applied on jumping
const MOVE_SPEED = 400			# Speed to walk with
const MOVE_ACCEL = 200			# Movement acceleration
const GRAVITY = 60				# Gravity applied every second
const MAX_SPEED = 4000			# Maximum speed the player is allowed to move
const FRICTION_AIR = 0.965		# The friction while airborne
const FRICTION_GROUND = 0.85	# The friction while on the ground
const CHAIN_LENGHT = 600		# Maximum lenght that chain can extend to
const CHAIN_PULL = 80
const AIR_JUMP_AMOUNT = 2		# Amount of jumps player is allowed before they touch ground

const FALL_DAMAGE = true
const FATAL_FALL_SPEED = 1000

const HIDE_OPACITY = 0.2		# Determines the opacity of player sprite when hiding

onready var last_checkpoint = self.global_position

var velocity = Vector2(0,0)		# The velocity of the player (kept over time)
var chain_velocity := Vector2(0,0)

var is_facing_right = true

var has_jumped = false			# To fix not double jumping after falling off a platform
var can_double_jump = true			# Whether the player used their double-jump

var jump_count = 0

var is_hiding = false

#might remove


var is_dead = false




func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT && !is_hiding:
			if event.pressed:
			# We clicked the mouse -> shoot()
				$Chain.shoot(event.position - get_viewport().size * 0.5)
				$HookShot.play()
			else:
			# We released the mouse -> release()
				$Chain.release()


func _ready():
	$left_run_particles.emitting = false
	$right_run_particles.emitting = false



func _physics_process(delta):
	manage_hook_physics(delta)


func _get_input_direction():
	var right = Input.get_action_strength("right")
	var left = Input.get_action_raw_strength("left")
	var direction = right - left
	
	if (direction < 0):	
		is_facing_right = false
	elif (direction > 0):
		is_facing_right = true
	
	return direction


func manage_hook_physics(delta):
	if $Chain.hooked:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		
		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			chain_velocity.y *= 1.65
		if sign(chain_velocity.x) != _get_input_direction():
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			chain_velocity.x *= 0.7
		
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)
	
	if $Chain.flying && ($Chain.tip - position).length() >= CHAIN_LENGHT:
		$Chain.release()
	
	
	velocity += chain_velocity
