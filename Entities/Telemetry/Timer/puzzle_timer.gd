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
	if body is Player and !timing:
		timing = true
	
func end_entered(body: Node3D):
	if body is not Player or !timing:
		return
	timing = false
	var data: Dictionary[String, Variant] = {
		"Puzzle " + str(puzzle): time
	}
	Talo.events.track(player + " puzzle", data)
	Talo.events.flush()
	set_process(false)
