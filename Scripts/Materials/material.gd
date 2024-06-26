class_name MyMaterial
extends RefCounted

# Abstract method
func get_ray_out(_ray_in: Ray, _rec: HitRecord) -> Ray:
	return null

# Abstract method
func get_attenuation() -> Color:
	return Color.BLACK
