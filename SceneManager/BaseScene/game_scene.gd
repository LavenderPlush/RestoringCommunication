class_name GameScene extends Node3D

signal finished

func finish_scene() -> void:
	finished.emit()
