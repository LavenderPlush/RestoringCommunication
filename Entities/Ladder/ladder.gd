extends Area3D

@onready var ladder: Area3D = $"."
var movement = "Movement"

func _ready() -> void:
	ladder.body_entered.connect(_on_body_entered)
	ladder.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is not Player: return
	body.can_climb = true

func _on_body_exited(body):
	if body is not Player: return
	body.can_climb = false
