class_name Util
extends RefCounted


static func random_vector(min_value: float, max_value: float) -> Vector3:
	randomize()
	var x = randf_range(min_value, max_value)
	var y = randf_range(min_value, max_value)
	var z = randf_range(min_value, max_value)
	return Vector3(x, y, z)


static func random_vector_in_unit_sphere():
	while(true):
		var vector = random_vector(-1, 1)
		if vector.length_squared() < 1:
			return vector


static func random_unit_vector() -> Vector3:
	return random_vector_in_unit_sphere().normalized()


static func random_on_hemisphere(normal: Vector3) -> Vector3:
	var on_unit_sphere = random_unit_vector()
	if on_unit_sphere.dot(normal) > 0:
		return on_unit_sphere
	else:
		return on_unit_sphere * -1


static func linear_to_gamma(linear_component: float):
	if linear_component > 0: return sqrt(linear_component)
	else: return 0


# Return true if the vector is close to zero in all dimensions
static func vector_is_near_zero(v: Vector3) -> bool:
	var s = 1e-8
	return  abs(v.x) < s and abs(v.y) < s and abs(v.z) < s


static func reflect(v: Vector3, normal: Vector3) -> Vector3:
	return v - 2 * v.dot(normal) * normal


static func refract(v: Vector3, normal: Vector3, etai_over_etat) -> Vector3:
	var cos_theta = min((v * -1).dot(normal), 1.0)
	var r_out_perp: Vector3 = etai_over_etat * (v + cos_theta * normal)
	var r_out_parallel: Vector3 = -1 * sqrt(abs(1.0 - r_out_perp.length_squared())) * normal
	return r_out_perp + r_out_parallel


static func random_in_unit_disk() -> Vector3:
	while true:
		var p = Vector3(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0, 0)
		if p.length_squared() < 1: return p
	return Vector3(0, 0, 0)


static func create_two_d_array(n: int):
	var two_d_array = []
	for i in range(n):
		var row = []
		for j in range(n):
			row.append(null)
		two_d_array.append(row)
	return two_d_array
