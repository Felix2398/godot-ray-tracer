class_name Ray
extends RefCounted

var origin: Vector3
var direction: Vector3

func at(t):
	return origin + t * direction
