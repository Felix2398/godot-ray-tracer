extends TextureRect

const WIDTH = 800
const HEIGHT = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	# camera
	var viewport_height = 2.0
	var viewport_width = viewport_height * (float(WIDTH) / HEIGHT)
	var focal_length = 1.0
	var camera_center = Vector3(0, 0, 0)
	
	# calculate viewport corners
	var viewport_upper_right = Vector3(viewport_width, 0, 0)
	var viewport_bottom_left = Vector3(0, -viewport_height, 0)
	
	# calculate the space between each pixel
	var delta_x = viewport_upper_right / WIDTH
	var delta_y = viewport_bottom_left / HEIGHT
	
	# calculate the position of the upper left pixel
	var viewport_upper_left = camera_center
	viewport_upper_left -= Vector3(0, 0, focal_length)
	viewport_upper_left -= viewport_upper_right / 2
	viewport_upper_left -= viewport_bottom_left / 2
	
	var start_pixel = viewport_upper_left + 0.5 * (delta_x + delta_y)
	print(start_pixel)
	
	# render image
	var image = Image.new()
	image = Image.create(WIDTH, HEIGHT, false, Image.FORMAT_RGB8)
	for x in WIDTH:
		for y in HEIGHT:
			var pixel_center = start_pixel + (x * delta_x) + (y * delta_y)
			var ray_direction = pixel_center - camera_center
			var ray = Ray.new()
			ray.origin = camera_center
			ray.direction = ray_direction
			
			image.set_pixel(x, y, ray_color(ray))
	image.save_png("render.png")
	texture = ImageTexture.create_from_image(image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ray_color(ray: Ray):
	var t = hit_sphere(Vector3(0, 0, -1), 0.5, ray)
	if t > 0:
		var n = (ray.at(t) - Vector3(0,0,-1)).normalized()
		return 0.5 * Color(n.x + 1, n.y + 1, n.z + 1)
	else:
		var normalized_direction = ray.direction.normalized()
		var a = 0.5 * (normalized_direction.y + 1.0)
		return (1.0 - a) * Color.WHITE + a * Color.SKY_BLUE

func hit_sphere(center: Vector3, radius: float, ray: Ray) -> float:
	var oc = center - ray.origin
	var a = ray.direction.length_squared()
	var h = ray.direction.dot(oc)
	var c = oc.length_squared() - pow(radius, 2)
	var dis = pow(h, 2) - a * c
	if dis < 0:
		return -1
	else:
		return (h - sqrt(dis)) / a
