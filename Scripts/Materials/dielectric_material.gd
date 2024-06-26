class_name DielectricMaterial
extends MyMaterial

var refraction_index: float

func _init(dielectric_refraction_index: float):
	self.refraction_index = dielectric_refraction_index

func get_ray_out(ray_in: Ray, rec: HitRecord) -> Ray:
	var ri: float = refraction_index
	if (rec.front_face): ri = 1.0 / refraction_index
	
	var unit_direction: Vector3 = ray_in.direction.normalized()
	var cos_theta: float = min((unit_direction * -1).dot(rec.normal), 1.0)
	var sin_theta: float = sqrt(1.0 - pow(cos_theta, 2))
	
	var cannot_refract: bool = ri * sin_theta > 1.0
	var direction: Vector3
	if cannot_refract: direction = Util.reflect(unit_direction, rec.normal)
	else: direction = Util.refract(unit_direction, rec.normal, ri)
	var ray_out: Ray = Ray.new(rec.p, direction)

	return ray_out

func get_attenuation() -> Color:
	return Color.WHITE
