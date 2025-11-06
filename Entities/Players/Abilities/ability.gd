@abstract
class_name Ability extends Node

signal engaged
signal disengaged

func engange():
	engaged.emit()

func disengage():
	disengaged.emit()

@abstract
func process_ability() -> void
