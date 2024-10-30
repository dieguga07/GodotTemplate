extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@onready var state_machine = $Player_State_Machine["parameters/playback"]

@export var magic_ball_scene: PackedScene
var last_direction = 1  


@export var throw_cooldown: float = 0.5
var can_throw = true

func _ready():
	add_to_group("player")

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

  	# Manejar lanzamiento de magia
	if Input.is_action_just_pressed("throw_attack") and can_throw:
		launch_magic_ball(direction)
		can_throw = false  # Desactivar el lanzamiento

	# Actualizar el cooldown
	if not can_throw:
		throw_cooldown -= delta
		if throw_cooldown <= 0:
			can_throw = true
			throw_cooldown = 0.5

	# Manejar movimiento
	if direction != 0:
		# Rote el sprite según la dirección
		last_direction = direction
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
	
func launch_magic_ball(direction: float):
	# Crear la bola de magia
	state_machine.travel("attack")
	var magic_ball = magic_ball_scene.instantiate()
	# Establecer la posición inicial (donde se lanzará la bola)
	magic_ball.position = global_position + Vector2(direction, -15)  # Lanzar desde un poco arriba del personaje
	
	# Establecer la dirección de la bola de magia según la dirección del personaje
	var ball_direction = Vector2(direction if direction != 0 else last_direction, 0).normalized()

	magic_ball.set_direction(ball_direction)
	
	# Añadir la bola de magia a la escena
	get_parent().add_child(magic_ball)
