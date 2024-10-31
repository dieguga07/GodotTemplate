extends CharacterBody2D

@export var speed = 20.0
@export var damage = 25.0
@export var gravity = 200.0
@export var direction = 1
@export var health = 120

@onready var timer: Timer = $Timer
@onready var golem_sprite: AnimatedSprite2D = $Golem_Sprite

var player_in_area = false

func _ready():
	timer.start()
	
	
func _physics_process(delta):
	velocity.x = speed * direction 
	velocity.y += gravity * delta
	golem_sprite.flip_h = direction == -1
	
	move_and_slide()


func _on_timer_timeout():
		direction = -direction
	
func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true

func _on_attack_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		
func _on_attack_right_body_entered(body):
	if body.is_in_group("player"):
		direction = 1
		golem_sprite.play("attack")
		await golem_sprite.animation_finished
		if player_in_area:
			body.get_damage(damage)
		golem_sprite.play("walk")

func _on_attack_left_body_entered(body):
	if body.is_in_group("player"):
		direction = -1
		golem_sprite.play("attack")
		await golem_sprite.animation_finished
		if player_in_area:
			body.get_damage(damage)
		golem_sprite.play("walk")
		
