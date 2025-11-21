extends GameScene

@export_category("Developers")
@export var exit_manager: ExitManager

func _ready() -> void:
	exit_manager.exit.connect(finish_scene)
