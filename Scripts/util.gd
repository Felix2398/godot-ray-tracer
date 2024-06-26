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
