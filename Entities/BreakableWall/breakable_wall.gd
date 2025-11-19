extends StaticBody3D

@onready var destruction_area: Area3D = $DestructionArea

func _ready() -> void:
	destruction_area.connect("body_entered", _on_destruction_area_entered)

func _on_destruction_area_entered(body: Node3D) -> void:
	if body is Interactable and body.is_thrown:
		queue_free()
