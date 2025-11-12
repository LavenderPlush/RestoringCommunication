extends Area3D

@export_category("Designers")
@export var human_spawn: Marker3D
@export var alien_spawn: Marker3D
@export var checkpoint_id: int = 0

var players_in_area: Dictionary = {}

func _ready():
    body_entered.connect(_on_body_entered)

func activate_checkpoint():
    CheckpointManager.set_active_checkpoint(human_spawn.global_transform, alien_spawn.global_transform, checkpoint_id)

    set_deferred("monitoring", false)

func _on_body_entered(body: Node3D):
    if body is Player and not players_in_area.has(body):
        players_in_area[body] = true

        if players_in_area.size() == 2:
            activate_checkpoint()