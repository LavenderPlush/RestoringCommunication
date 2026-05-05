extends Node

@export_category("Telemetry data")
@export var puzzle: int = 1
@export_enum("human", "alien") var player: String

@export_category("Checkpoints")
@export var start: Area3D
@export var end: Area3D

var timing: bool = false
var time: float = 0
var completed: bool = false

func _ready() -> void:
	if start:
		start.body_entered.connect(start_entered)
	else:
		timing = true
	end.body_entered.connect(end_entered)

func _process(delta: float) -> void:
	if not timing or completed:
		return
	time += delta

func start_entered(body: Node3D):
	if body is Player and !timing and !completed:
		timing = true
	
func end_entered(body: Node3D):
	if body is not Player or !timing or completed:
		return
	timing = false
	var data: Dictionary[String, Variant] = {
		"Puzzle " + str(puzzle): time
	}
	Talo.events.track(player + " puzzle", data)
	Talo.events.flush()
	completed = true
