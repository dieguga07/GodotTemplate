extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0

@onready var state_machine = $Player_State_Machine["parameters/playback"]

func _physics_process(delta: float) -> void:
	
	# Aplicar gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Obtener la dirección de entrada
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# Manejar salto.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		state_machine.travel("jump")

	# Manejar ataque.
	if Input.is_action_just_pressed("attack"):
		state_machine.travel("attack")

	# Manejar movimiento
	if direction != 0:
		# Rote el sprite según la dirección
		$Player_Sprite.flip_h = direction < 0
		velocity.x = direction * SPEED
		state_machine.travel("walk")  # Cambiar a caminar
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Cambiar a estado de idle si está en el suelo y no se mueve
	if is_on_floor() and velocity.x == 0:
		state_machine.travel("idle")  # Cambia al estado de idle

	# Cambiar a estado de caída si no está en el suelo
	if not is_on_floor():
		if velocity.y < 0:
			state_machine.travel("jump")  


	move_and_slide()
