extends CharacterBody3D
class_name TransmuteController

@export var movement: PlayerMovement

func release():
	movement.queue_free()
