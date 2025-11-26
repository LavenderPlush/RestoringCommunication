class_name GameScene extends Node3D

enum branches {
	First = 1,
	Second = 2
}

signal finished
signal finished_branch(branch: int)

func finish_scene() -> void:
	finished.emit()

func finish_and_branch(branch: branches) -> void:
	finished_branch.emit(branch)
