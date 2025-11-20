class_name GameScene extends Node

signal finished

func finish_scene() -> void:
	finished.emit()
