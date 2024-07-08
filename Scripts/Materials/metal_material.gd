class_name MetalMaterial
extends MyMaterial

var albedo: Color
var fuzz: float


func _init(material_color: Color, material_fuzz):
	self.albedo = material_color
	self.fuzz = material_fuzz


func get_ray_out(ray_in: Ray, rec: HitRecord) -> Ray:
	var reflected = Util.reflect(ray_in.direction, rec.normal)
	reflected = reflected.normalized() + (fuzz * Util.random_unit_vector())
	var ray_out = Ray.new(rec.p, reflected)
	
	if ray_out.direction.dot(rec.normal) > 0: return ray_out
	else: return null


func get_attenuation() -> Color:
	return self.albedo
