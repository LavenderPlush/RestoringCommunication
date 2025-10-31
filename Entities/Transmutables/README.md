# Transmutable objects

## Grouping
Transmutable objects must be added to the group "Transmutable".

## Structure
Transmutable objects must either have the transmutable script attached
or derive from the Transmutable class.
The root node must be of Node3D and must have a direct child node of RigidBody3D:
Node3D (Script: e.g. transmutable.gd)
- RigidBody3D
	- Mesh
	- CollisionShape
	- etc.
