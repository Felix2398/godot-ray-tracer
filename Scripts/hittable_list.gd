class_name HittableList
extends Hittable

var objects = []

func add(object: Hittable):
	objects.append(object)
	
func clear():
	objects = []

func hit(ray: Ray, ray_tmin: float, ray_tmax: float, rec: HitRecord) -> bool:
	var temp_rec = HitRecord.new()
	var hit_anything = false
	var closest_so_far = ray_tmax
	
	for object in objects:
		var isHit = object.hit(ray, ray_tmin, closest_so_far, temp_rec)
		if (isHit):
			hit_anything = true
			closest_so_far = temp_rec.t
			rec.copy_from(temp_rec)
	
	return hit_anything
