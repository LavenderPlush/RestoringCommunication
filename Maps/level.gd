extends GameScene

@export_category("Developers")
@export var exit_manager: ExitManager

func _ready() -> void:
	exit_manager.exit.connect(finish)

# Used for branching cutscenes
func finish(first_player_out: int) -> void:
	finished.emit(first_player_out)
