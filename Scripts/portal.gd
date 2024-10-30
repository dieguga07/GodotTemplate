extends Area2D

@export var target_scene: String  # Ruta de la escena a la que se teleportará
@export var scene = "res://Scenes/level_2.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("teleport...")
		get_tree().change_scene_to_file(scene)
