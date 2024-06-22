extends TextureRect

var current_sample: int
var max_samples: int
var thread: Thread
var image: Image
var result: Image
var new_image_ready: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	current_sample = 0
	start_render_thread()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (new_image_ready):
		if (result == null):
			result = image
		else:
			result = blend_images(result, image)
		result.save_png("render.png")
		texture = ImageTexture.create_from_image(result)
		current_sample += 1
		start_render_thread()

func start_render_thread():
	new_image_ready = false;
	thread = Thread.new()
	thread.start(render.bind())

func render():
	# world
	var world = HittableList.new()
	world.add(Sphere.new(Vector3(0, 0, -1), 0.5))
	world.add(Sphere.new(Vector3(0, -100.5, -1), 100))
	
	# init camera and render image
	var cam = RenderCamera.new()
	cam.image_width = 400
	cam.image_height = 300
	cam.samples_per_pixel = 1
	cam.max_ray_bounces = 5
	image = cam.render(world)
	new_image_ready = true

func blend_images(image1: Image, image2: Image) -> Image:
	var result_image = Image.new()
	result_image = Image.create(image1.get_width(), image1.get_height(), false, Image.FORMAT_RGBA8)
	for x in range(image1.get_width()):
		for y in range(image1.get_height()):
			var color1 = image1.get_pixel(x, y)
			var color2 = image2.get_pixel(x, y)
			var r = (color1.r * current_sample + color2.r) / (current_sample + 1)
			var g = (color1.g * current_sample + color2.g) / (current_sample + 1)
			var b = (color1.b * current_sample + color2.b) / (current_sample + 1)
			var avg_color = Color(r, g, b)
			result_image.set_pixel(x, y, avg_color)
			
	return result_image
