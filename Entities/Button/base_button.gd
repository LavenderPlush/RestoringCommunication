extends AnimatableBody3D
class_name ButtonBase

signal player_entered(body: Node3D)
signal player_exited(body: Node3D)

##This Object will keep resetting until Players reach this Checkpoint ID. Keep at -1 to always reset.
@export var reset_until_checkpoint_id: int = -1

@onready var activation_area: Area3D = $ActivationArea

var original_position: Vector3
var animation_duration: float = 0.2

func _ready() -> void:
	original_position = self.position

	add_to_group("resettable")

	activation_area.body_entered.connect(_on_body_entered)
	activation_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player") || body is Interactable:
		player_entered.emit(body)

func _on_body_exited(body):
	if body.is_in_group("Player") || body is Interactable:
		player_exited.emit(body)
	
func animate_button(target_y: float):
	var tween = create_tween()
	
	tween.tween_property(self, "position:y", target_y, animation_duration)

func reset_state():
	pass