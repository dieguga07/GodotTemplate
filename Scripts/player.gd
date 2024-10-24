extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -250.0

@onready var state_machine : AnimationTree = $Player_State_Machine

func _ready():
	state_machine.active = true
	
func _process(delta):
	update_animation_parameters()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		state_machine["parameters/conditions/is_jumping"] = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		state_machine["parameters/conditions/is_jumping"] = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		state_machine["parameters/conditions/is_jumping"] = false
	move_and_slide()
	
func update_animation_parameters():
	if (velocity.x == 0):
		state_machine["parameters/conditions/is_idle"] = true
		state_machine["parameters/conditions/is_walking"] = false
	else : 
		state_machine["parameters/conditions/is_idle"] = false
		state_machine["parameters/conditions/is_walking"] = true	
		
		
		
		
