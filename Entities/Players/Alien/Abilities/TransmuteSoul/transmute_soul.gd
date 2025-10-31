extends Node

@export_category("Developers")
@export var interaction_area: Area3D
@export var movement: PlayerMovement
@export var alien_body: CharacterBody3D

var transmutable_object: Node3D

func _ready() -> void:
	interaction_area.body_entered.connect(_body_entered)
	
func _body_entered():
	pass
