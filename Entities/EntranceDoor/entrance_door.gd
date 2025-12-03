class_name EntranceDoor extends Node3D

@export_category("Developers")
@export var animation_player: AnimationPlayer

func _ready() -> void:
	animation_player.play("open")

func open():
	animation_player.play("open")

func reset():
	animation_player.play("RESET")
