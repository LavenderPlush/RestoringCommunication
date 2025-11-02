extends Area3D

@onready var ladder: Area3D = $"."
var movement = "Movement"

func _ready() -> void:
	ladder.body_entered.connect(_on_body_entered)
	ladder.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if not body.is_in_group("Player"): return

	if body.has_node(movement):
		body.get_node(movement).set_is_climbing(true)

func _on_body_exited(body):
	if not body.is_in_group("Player"): return

	if body.has_node(movement):
		body.get_node(movement).set_is_climbing(false)
