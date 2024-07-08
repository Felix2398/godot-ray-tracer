class_name LambertianMaterial
extends MyMaterial

var albedo: Color


func _init(albedo_color: Color):
	self.albedo = albedo_color


func get_ray_out(_ray_in: Ray, rec: HitRecord) -> Ray:
	var scatter_direction = rec.normal + Util.random_unit_vector()
	if Util.vector_is_near_zero(scatter_direction): scatter_direction = rec.normal
	return Ray.new(rec.p, scatter_direction)


func get_attenuation() -> Color:
	return self.albedo
