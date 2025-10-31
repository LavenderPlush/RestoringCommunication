extends Node3D
class_name Transmutable

@export var rigid_body: RigidBody3D:
	get:
		return rigid_body

var character_body: CharacterBody3D:
	set(body):
		character_body = body
	get:
		return character_body
