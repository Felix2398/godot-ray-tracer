class_name HitRecord
extends RefCounted

var p: Vector3
var normal: Vector3
var t: float
var front_face: bool

func set_face_normal(ray: Ray, outward_normal: Vector3):
	# its assumed that outward_normal has unit length
	front_face = ray.direction.dot(outward_normal) < 0
	if front_face:
		self.normal = outward_normal
	else:
		self.normal = outward_normal * -1
