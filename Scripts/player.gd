extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -250.0

@onready var state_machine : AnimationTree = $Player_State_Machine

func _ready():
	state_machine.active = true
	
func _process(delta):
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
	   # Rote el sprite según la dirección
		$Player_Sprite.flip_h = direction < 0
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	update_animation(direction)
	
func update_animation(move):
	
	state_machine.set("parameters/Move/blend_position",move)		
		
