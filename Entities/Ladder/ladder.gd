extends Area3D

@onready var ladder: Area3D = $"."

@export_category("Designers")
##This Object will keep resetting until Players reach this Checkpoint ID. Keep at -1 to always reset.
@export var reset_until_checkpoint_id: int = -1
##True for extendable ladders (used for buttons). False for normal ladders.
@export var is_extendable: bool = false

@export_category("Developers")
@export var extendable_part: Node3D
@export var pre_existing_part: Node3D
@export var climb_snap_point: Node3D
@export var collision: CollisionShape3D

var is_extended: bool = false

func _ready() -> void:
	add_to_group("resettable")

	ladder.body_entered.connect(_on_body_entered)
	ladder.body_exited.connect(_on_body_exited)
	
	if is_extendable && extendable_part != null && pre_existing_part != null:
		_set_active(false)

#Taking a page from Unity. Sad Godot doesn't have this :(.
func _set_active(state: bool):
	extendable_part.visible = state
	pre_existing_part.visible = !state
	collision.disabled = !state
	ladder.monitoring = state

func extend_ladder():
	if is_extended: return

	is_extended = true

	_set_active(true)

	var tween = create_tween()

	tween.tween_property(extendable_part, "position:y", 0, 1).set_trans(Tween.TRANS_QUAD)

func _on_body_entered(body):
	if body is not Player: return

	body.set_can_climb(true)
	body.set_climb_snap(climb_snap_point.global_position.z)

func _on_body_exited(body):
	if body is not Player: return

	body.set_can_climb(false)

func reset_state():
	if is_extendable and is_extended:
		is_extended = false
		
		_set_active(false)