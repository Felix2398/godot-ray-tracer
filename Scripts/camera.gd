class_name RenderCamera
extends RefCounted

var camera_id: int

var image_width: int
var image_height: int

var samples_per_pixel: int
var pixel_sample_scale: float

var camera_center = Vector3(0, 0, 0)

var start_pixel: Vector3
var delta_x: Vector3
var delta_y: Vector3

var u: Vector3
var v: Vector3
var w: Vector3

var max_ray_bounces: int

var vfov: float = 90
var look_from: Vector3 = Vector3(0,0,0)
var look_at: Vector3 = Vector3(0,0,-1)
var vup: Vector3 = Vector3(0,1,0)

var chunk_start: Vector2
var chunk_end: Vector2

var defocus_angle: float = 0
var focus_dist: float = 10
var defocus_disk_u: Vector3
var defocus_disk_v: Vector3


func _init():
	self.image_width = Settings.image_width
	self.image_height = Settings.image_height
	self.samples_per_pixel = Settings.samples_per_pixel
	self.max_ray_bounces = Settings.max_ray_bounces
	
	self.vfov = Settings.vfov
	self.look_from = Settings.look_from
	self.look_at = Settings.look_at
	self.vup = Settings.vup
	
	self.defocus_angle = Settings.defocus_angle
	self.focus_dist = Settings.focus_dist


# Calculates all necessary values for the rendering 
func initialize():
	camera_center = look_from
	pixel_sample_scale = 1.0 / samples_per_pixel
	
	# Calculate the viewport
	var theta: float = deg_to_rad(vfov)
	var h: float = tan(theta / 2)
	var viewport_height: float = 2.0 * h * focus_dist
	var viewport_width = viewport_height * (float(image_width) / image_height)
	
	# Camera frame basis vectors
	w = (look_from - look_at).normalized()
	u = (vup.cross(w)).normalized()
	v = w.cross(u)
	
	# Calculate viewport corners
	var viewport_upper_right = viewport_width * u
	var viewport_bottom_left = viewport_height * -v
	
	# Calculate the space between each pixel
	delta_x = viewport_upper_right / image_width
	delta_y = viewport_bottom_left / image_height
	
	# Calculate the position of the upper left pixel
	var viewport_upper_left = camera_center
	viewport_upper_left -= (focus_dist * w)
	viewport_upper_left -= viewport_upper_right / 2
	viewport_upper_left -= viewport_bottom_left / 2
	start_pixel = viewport_upper_left + 0.5 * (delta_x + delta_y)
	
	# Calculate the camera defocus disk basis vectors
	var defocus_radius = focus_dist * tan(deg_to_rad(defocus_angle / 2))
	defocus_disk_u = u * defocus_radius
	defocus_disk_v = v * defocus_radius


# Loops over every pixel in the image and calculates the color
func render(world: Hittable) -> Image:
	initialize()
	
	var chunk_width = (chunk_end.x - chunk_start.x)
	var image = Image.new()
	image = Image.create(image_width, image_height, false, Image.FORMAT_RGB8)
	
	for y in range(chunk_start.y, chunk_end.y):
		for x in range(chunk_start.x, chunk_end.x):
			# Update status info
			var oy = (y - chunk_start.y)
			var ox = (x - chunk_start.x)
			Status.current_pixel_ids[camera_id] = oy * chunk_width + ox  + 1
			
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
	
	var ray_origin
	if (defocus_angle <= 0): ray_origin = camera_center
	else: ray_origin = defocus_disk_sample()
	
	var ray_direction = pixel_sample - ray_origin
	return Ray.new(ray_origin, ray_direction)


func sample_square() -> Vector3:
	return Vector3(randf() - 0.5, randf() - 0.5, 0)


# Returns a random point in the camera defocus disk
func defocus_disk_sample() -> Vector3:
	var p = Util.random_in_unit_disk()
	return camera_center + (p.x * defocus_disk_u) + (p.y * defocus_disk_v)


func get_copy() -> RenderCamera:
	var cam = RenderCamera.new()
	cam.image_width = self.image_width
	cam.image_height = self.image_height
	cam.samples_per_pixel = self.samples_per_pixel
	cam.max_ray_bounces = self.max_ray_bounces
	
	cam.vfov = self.vfov
	cam.look_from = self.look_from
	cam.look_at = self.look_at
	cam.vup = self.vup
	
	cam.defocus_angle = self.defocus_angle
	cam.focus_dist = self.focus_dist
	
	return cam
