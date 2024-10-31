extends Area2D
@export var speed =250
@export var damage = 25

var direction:Vector2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	await get_tree().create_timer(0.6).timeout
	animated_sprite_2d.play("explosion")
	set_direction(Vector2.ZERO)
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
func set_direction(bulletDirection):
	direction = bulletDirection.normalized()
	
	
func _physics_process(delta):
	if animated_sprite_2d.animation != "explosion":
		global_position += direction * speed * delta



func _on_body_entered(body):
	if body.is_in_group("enemies"):
		print("damage")
		body.get_damage(damage)
		queue_free()
