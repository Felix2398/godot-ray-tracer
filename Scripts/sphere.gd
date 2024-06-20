class_name Sphere
extends Hittable

var center: Vector3
var radius: float

func _init(sphere_center: Vector3, sphere_radius: float):
	self.center = sphere_center
	self.radius = sphere_radius

func hit(ray: Ray, ray_tmin: float, ray_tmax: float, rec: HitRecord) -> bool:
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
	if (root <= ray_tmin || root >= ray_tmax):
		root = (h + sqrtd) / a
		if (root <= ray_tmin || root >= ray_tmax):
			return false
			
	rec.t = root
	rec.p = ray.at(rec.t)
	var outward_normal = (rec.p - center) / radius
	rec.set_face_normal(ray, outward_normal)
	
	return true

func print():
	print("%v, %f",center, radius)
