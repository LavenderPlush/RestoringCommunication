extends StaticBody3D

@onready var destruction_area: Area3D = $DestructionArea

var wall_break_particles: PackedScene = preload("res://Entities/BreakableWall/wall_break_particles.tscn")

func _ready() -> void:
	destruction_area.connect("body_entered", _on_destruction_area_entered)

func _on_destruction_area_entered(body: Node3D) -> void:
	if body is Interactable and body.is_thrown:
		var particles = wall_break_particles.instantiate()
		particles.global_position = global_position
		get_parent().add_child(particles)
		queue_free()
