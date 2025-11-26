class_name ExitDoor extends Node3D

@export_category("Developers")
@export var animation_player: AnimationPlayer

func open():
	animation_player.play("open")

func reset():
	animation_player.play("RESET")
