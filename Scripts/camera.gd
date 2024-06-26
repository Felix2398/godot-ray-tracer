class_name RenderCamera
extends RefCounted

var image_width: int
var image_height: int

var samples_per_pixel: int
var pixel_sample_scale: float

var camera_center = Vector3(0, 0, 0)
var focal_length = 1.0

var start_pixel: Vector3
var delta_x: Vector3
var delta_y: Vector3

var max_ray_bounces: int

func initialize():
	var viewport_height = 2.0
	var viewport_width = viewport_height * (float(image_width) / image_height)
	
	pixel_sample_scale = 1.0 / samples_per_pixel

	# calculate viewport corners
	var viewport_upper_right = Vector3(viewport_width, 0, 0)
	var viewport_bottom_left = Vector3(0, -viewport_height, 0)
	
	# calculate the space between each pixel
	delta_x = viewport_upper_right / image_width
	delta_y = viewport_bottom_left / image_height
	
	# calculate the position of the upper left pixel
	var viewport_upper_left = camera_center
	viewport_upper_left -= Vector3(0, 0, focal_length)
	viewport_upper_left -= viewport_upper_right / 2
	viewport_upper_left -= viewport_bottom_left / 2
	start_pixel = viewport_upper_left + 0.5 * (delta_x + delta_y)

func render(world: Hittable) -> Image:
	initialize()
	
	var image = Image.new()
	image = Image.create(image_width, image_height, false, Image.FORMAT_RGB8)
	
	Status.current_max_pixel = image_width * image_height
	
	for y in image_height:
		for x in image_width:
			# Update status info
			Status.current_pixel_id = y * image_width + x + 1;
			
			var pixel_color = Color(0, 0, 0)
			for sample in range(samples_per_pixel):
				var ray = get_ray(x, y)
				pixel_color += ray_color(ray, max_ray_bounces, world)
			var linear_color = pixel_sample_scale * pixel_color
			
			var r = Util.linear_to_gamma(linear_color.r)
			var g = Util.linear_to_gamma(linear_color.g)
			var b = Util.linear_to_gamma(linear_color.b)
			var gamma_color = Color(r, g, b)
			
			image.set_pixel(x, y, gamma_color)
	
	return image

func ray_color(ray: Ray, depth: int, world: Hittable):
	if depth <= 0: return Color(0.0, 0.0, 0.0)
	
	var rec = HitRecord.new()
	if (world.hit(ray, Interval.new(0.01, INF), rec)):
		if rec.mat == null: return Color.DEEP_PINK
		
		var ray_out = rec.mat.get_ray_out(ray, rec)
		if ray_out != null: return rec.mat.get_attenuation() * ray_color(ray_out, depth - 1, world)
		else: return Color(0.0, 0.0, 0.0)
	else:
		var normalized_direction = ray.direction.normalized()
		var a = 0.5 * (normalized_direction.y + 1.0)
		return (1.0 - a) * Color(1.0, 1.0, 1.0) + a * Color(0.5, 0.7, 1.0)

func get_ray(x: int, y: int) -> Ray:
	var offset = sample_square()
	var pixel_sample = start_pixel + ((x + offset.x) * delta_x) + ((y + offset.y) * delta_y)
	var ray_origin = camera_center
	var ray_direction = pixel_sample - camera_center
	return Ray.new(ray_origin, ray_direction)

func sample_square() -> Vector3:
	return Vector3(randf() - 0.5, randf() - 0.5, 0)
