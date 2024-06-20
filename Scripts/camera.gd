class_name RenderCamera
extends RefCounted

var image_width = 800
var image_height = 600

var camera_center = Vector3(0, 0, 0)
var focal_length = 1.0

var start_pixel: Vector3
var delta_x: Vector3
var delta_y: Vector3

func initialize():
	var viewport_height = 2.0
	var viewport_width = viewport_height * (float(image_width) / image_height)

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
	for x in image_width:
		for y in image_height:
			var pixel_center = start_pixel + (x * delta_x) + (y * delta_y)
			var ray_direction = pixel_center - camera_center
			var ray = Ray.new(camera_center, ray_direction)
			
			var color = ray_color(ray, world)
			image.set_pixel(x, y, color)
	
	return image

func ray_color(ray: Ray, world: Hittable):
	var rec = HitRecord.new()
	if (world.hit(ray, Interval.new(0, INF), rec)):
		var c = rec.normal + Vector3(1, 1, 1)
		return 0.5 * Color(c.x, c.y, c.z)
	else:
		var normalized_direction = ray.direction.normalized()
		var a = 0.5 * (normalized_direction.y + 1.0)
		return (1.0 - a) * Color.WHITE + a * Color.SKY_BLUE
