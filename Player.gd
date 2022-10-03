extends KinematicBody2D

const ACCELERATION = 300
const FRICTION = 400
const MAX_SPEED = 100

enum{
	MOVE,
	ATTACK,
	ROLL
}

var state
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationStatus = animationTree.get("parameters/playback")

func _ready():
	state = MOVE
	animationTree.active = true
	
func _physics_process(delta):
	match state:
		MOVE:
			state_move(delta)
		ATTACK:
			state_attack()
		ROLL:
			pass

func state_move(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		
		animationStatus.travel("Run")		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationStatus.travel("Idle")		
		velocity = velocity.move_toward(input_vector, FRICTION * delta)
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	velocity = move_and_slide(velocity)

func state_attack():
	animationStatus.travel("Attack")

func attack_animation_finished():
		state = MOVE
