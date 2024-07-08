class_name MyPlane
extends Hittable

var p0: Vector3
var normal: Vector3
var material: MyMaterial

func _init(p: Vector3, n: Vector3, m: MyMaterial):
	self.p0 = p
	self.normal = n.normalized()
	self.material = m

func hit(ray: Ray, ray_t: Interval, rec: HitRecord) -> bool:
	var denom = normal.dot(ray.direction)
	if abs(denom) > 1e-6:
		var v = p0 - ray.origin
		var t = v.dot(normal) / denom
		
		if !ray_t.surrounds(t): return false
		
		rec.t = t
		rec.p = ray.at(rec.t)
		rec.set_face_normal(ray, normal)
		rec.mat = material
		return true
	
	return false
