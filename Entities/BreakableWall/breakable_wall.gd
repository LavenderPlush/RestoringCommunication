extends StaticBody3D

@export_category("Designers")
##This Object will keep resetting until Players reach this Checkpoint ID. Keep at -1 to always reset.
@export var reset_until_checkpoint_id: int = -1


@onready var destruction_area: Area3D = $DestructionArea
@onready var destruction_collider: CollisionShape3D = $DestructionArea/CollisionShape3D
@onready var mesh: MeshInstance3D = $Mesh/Cube_003
@onready var collider: CollisionShape3D = $CollisionShape3D

@onready var break_sound_emitter: FmodEventEmitter3D = $BreakSoundEmitter

var wall_break_particles: PackedScene = preload("res://Entities/BreakableWall/wall_break_particles.tscn")

func _ready() -> void:
	add_to_group("resettable")

	destruction_area.connect("body_entered", _on_destruction_area_entered)

func _set_active(state: bool):
	destruction_area.visible = state
	mesh.visible = state
	collider.set_deferred("disabled", !state)
	destruction_collider.set_deferred("disabled", !state)

func _on_destruction_area_entered(body: Node3D) -> void:
	if body is Interactable and body.is_thrown:
		var particles = wall_break_particles.instantiate()

		get_parent().add_child(particles)

		particles.global_position = global_position

		break_sound_emitter.play()

		_set_active(false)

func reset_state():
	_set_active(true)
