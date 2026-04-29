extends Node

@export_category("Telemetry data")
@export var puzzle: int = 1
@export_enum("human", "alien") var player: String

@export_category("Checkpoints")
@export var start: Area3D
@export var end: Area3D

var timing: bool = false
var time: float = 0

func _ready() -> void:
	start.body_entered.connect(start_entered)
	end.body_entered.connect(end_entered)

func _process(delta: float) -> void:
	if not timing:
		return
	time += delta

func start_entered(body: Node3D):
	if body is not Player or timing:
		return
	
func end_entered(body: Node3D):
	if body is not Player or not timing:
		return
	timing = false
	Talo.events.track(player + "_puzzle", {
		"puzzle_" + str(puzzle): str(time / 60.0)
	});
	set_process(false)
