"""
This script controls the Enemy.
"""
extends KinematicBody2D

enum {
	IDLE,
	CHANGE_DIRECTION,
	WALK,
	CHASE,
	DIE
}


const MOVE_SPEED = 200			# Speed to walk with
const GRAVITY = 60				# Gravity applied every second

var state: = IDLE
var direction = -1				# Determines the direction of the enemy
var velocity = Vector2(0,0)		# The velocity of the player (kept over time)

func _ready():
	randomize()

func _on_Bullet_Detector_body_entered(body):
	body.collide(self)
	state = DIE
	

# This function is called every physics frame
func _physics_process(_delta: float) -> void:
	velocity.y += GRAVITY
	
	match state:
		IDLE:
			move_and_slide(velocity, Vector2.UP)
		CHANGE_DIRECTION:
			if is_on_wall(): direction *= -1
			else: direction *= choose([-1, 1])
				
			state = choose([IDLE, CHANGE_DIRECTION, WALK])
		WALK:
			manage_velocity_change(MOVE_SPEED)
		CHASE:
			pass
		DIE:
			
			queue_free()


func manage_velocity_change(walk: float) -> void:	
	velocity.x = walk*direction
	move_and_slide(velocity, Vector2.UP)
	if is_on_wall(): direction *= -1

func choose(array):
	array.shuffle()
	return array[0]


func _on_Timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	state = choose([IDLE, CHANGE_DIRECTION, WALK])



