class_name Ray
extends RefCounted

var origin: Vector3
var direction: Vector3

func _init(ray_origin: Vector3, ray_direction: Vector3):
	self.origin = ray_origin
	self.direction = ray_direction

func at(t):
	return origin + t * direction
