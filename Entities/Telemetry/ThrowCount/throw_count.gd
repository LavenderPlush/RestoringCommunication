extends Node

@export_category("Areas")
@export var throw_area: Area3D
@export var wrong_landing_area: Area3D

var human_player: Human = null
var wrong_throws: int = 0

func _ready() -> void:
	throw_area.body_entered.connect(throw_area_entered)
	throw_area.body_exited.connect(throw_area_exited)
	wrong_landing_area.body_entered.connect(wrong_landing_entered)

func _process(_delta: float) -> void:
	if human_player == null:
		return

func throw_area_entered(body: Node3D):
	if body is not Human:
		human_player = body

func throw_area_exited(body: Node3D):
	if body is Human:
		human_player = null

func wrong_landing_entered(body: Node3D):
	if body is Interactable and human_player:
		wrong_throws += 1
		Talo.events.track("human_throw_fail", {
			"count": str(wrong_throws)
		})
