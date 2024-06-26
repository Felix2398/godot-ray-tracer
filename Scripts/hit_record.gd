class_name HitRecord
extends RefCounted

var p: Vector3
var normal: Vector3
var t: float
var front_face: bool
var mat: MyMaterial

func set_face_normal(ray: Ray, outward_normal: Vector3):
	# its assumed that outward_normal has unit length
	front_face = ray.direction.dot(outward_normal) < 0
	if front_face:
		normal = outward_normal
	else:
		normal = outward_normal * -1

func copy_from(other: HitRecord):
	self.p = other.p
	self.normal = other.normal
	self.t = other.t
	self.front_face = other.front_face
	self.mat = other.mat
