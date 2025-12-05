extends Control

@export var human: Player

@export var throw_x: LineEdit
@export var throw_y: LineEdit

var power_gloves: PowerGloves

func _ready() -> void:
	power_gloves = human.ability
	throw_x.text = str(power_gloves.throw_momentum.x)
	throw_y.text = str(power_gloves.throw_momentum.y)

func _process(_delta: float) -> void:
	power_gloves.throw_momentum.x = float(throw_x.text)
	power_gloves.throw_momentum.y = float(throw_y.text)
