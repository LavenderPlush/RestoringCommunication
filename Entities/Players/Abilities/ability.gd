@abstract
class_name Ability extends Node

signal engaged
signal disengaged

var available_objects: Array[Interactable] = []

func engange():
	engaged.emit()

func disengage():
	disengaged.emit()

@abstract
func process_ability() -> void

func get_closest_interactable(source_pos: Vector3, is_human: bool) -> Interactable:
	var closest_obj: Interactable = null
	var closest_dist: float = INF

	for obj in available_objects:
		obj.set_targeted(is_human, false)
		
		var dist = source_pos.distance_squared_to(obj.global_position)

		if dist < closest_dist:
			closest_dist = dist
			closest_obj = obj

	if closest_obj:
		closest_obj.set_targeted(is_human, true)
	
	return closest_obj

func _on_object_entered_area(body: Node3D):
	if body is Interactable and body not in available_objects:
		available_objects.append(body)

func _on_object_exited_area(body: Node3D):
	if body is Interactable:

		if available_objects.has(body):
			body.set_targeted(true, false) 
			body.set_targeted(false, false)
			available_objects.erase(body)