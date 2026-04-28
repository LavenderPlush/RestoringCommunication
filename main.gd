extends Node3D

func _ready():
	Talo.players.identify("test_service", Talo.players.generate_identifier())
	
