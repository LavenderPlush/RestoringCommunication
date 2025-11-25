extends GameScene

@export_category("Designers")
@export var branching: bool = false

@export_category("Developers")
@export var exit_manager: ExitManager

func _ready() -> void:
	exit_manager.exit.connect(exit_level)

# Used for branching cutscenes
func exit_level(first_player_out: String) -> void:
	if not branching:
		finished.emit()
		return
	
	print(first_player_out)

	match first_player_out:
		"Human":
			finished_branch.emit(branches.First)
		"Alien":
			finished_branch.emit(branches.Second)
		_:
			finished.emit()
