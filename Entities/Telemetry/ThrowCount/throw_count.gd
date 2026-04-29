extends Node

@export_category("Areas")
@export var throw_area: Area3D
@export var wrong_landing_area: Area3D

var throwing_area_active: bool = false
var wrong_throws: int = 0

	
func _ready() -> void:
	print(throw_area, wrong_landing_area)
	throw_area.body_entered.connect(throw_area_entered)
	throw_area.body_exited.connect(throw_area_exited)
	wrong_landing_area.body_entered.connect(wrong_landing_entered)

func throw_area_entered(body: Node3D):
	print("Player in throwing area")
	if body is Player:
		throwing_area_active = true

func throw_area_exited(body: Node3D):
	print("Player left throwing area")
	if body is Player:
		throwing_area_active = false

func wrong_landing_entered(body: Node3D):
	if body is Interactable and throwing_area_active:
		wrong_throws += 1
		var data: Dictionary[String, Variant] = {
			"Count": wrong_throws
		}
		Talo.events.track("human_throw_fail", data)
		Talo.events.flush()
