class_name HittableList
extends Hittable

var objects = []

func add(object: Hittable):
	objects.append(object)
	
func clear():
	objects = []

func hit(ray: Ray, ray_t: Interval, rec: HitRecord) -> bool:
	var temp_rec = HitRecord.new()
	var hit_anything = false
	var closest_so_far = ray_t.max_value
	
	for object in objects:
		var isHit = object.hit(ray, Interval.new(ray_t.min_value, closest_so_far), temp_rec)
		if (isHit):
			hit_anything = true
			closest_so_far = temp_rec.t
			rec.copy_from(temp_rec)
	
	return hit_anything
