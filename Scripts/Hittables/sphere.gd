class_name Sphere
extends Hittable

var center: Vector3
var radius: float
var material: MyMaterial

func _init(sphere_center: Vector3, sphere_radius: float, sphere_material: MyMaterial):
	self.center = sphere_center
	self.radius = sphere_radius
	self.material = sphere_material

func hit(ray: Ray, ray_t: Interval, rec: HitRecord) -> bool:
	var oc = center - ray.origin
	var a = ray.direction.length_squared()
	var h = ray.direction.dot(oc)
	var c = oc.length_squared() - pow(radius, 2)
	
	var dis = pow(h, 2) - a * c
	if dis < 0:
		return false
	
	var sqrtd = sqrt(dis)
	
	# find the nearest root that lies in the acceptable range
	var root = (h - sqrtd) / a
	if (!ray_t.surrounds(root)):
		root = (h + sqrtd) / a
		if (!ray_t.surrounds(root)):
			return false
			
	rec.t = root
	rec.p = ray.at(rec.t)
	var outward_normal = (rec.p - center) / radius
	rec.set_face_normal(ray, outward_normal)
	rec.mat = material
	
	return true
