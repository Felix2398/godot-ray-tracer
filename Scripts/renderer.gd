extends TextureRect

var current_sample: int
var max_samples: int
var thread: Thread
var texture_image: Image
var result: Image
var new_image_ready: bool

var s = 1
var image_width = int(800 / s)
var image_height = int(600 / s)

var thread_count: int = 4
var images = []
var threads = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize values for the status singleton
	Status.current_max_pixel = image_width * image_height
	for i in range(thread_count):
		Status.current_pixel_ids.append(0)
	
	var thread = Thread.new()
	thread.start(prepare_for_render.bind())


func prepare_for_render():
	current_sample = 0
	print(image_width)
	print(image_height)
	
	for i in range(thread_count):
		images.append(null)
		var thread = Thread.new()
		threads.append(thread)
	
	render()
	
	for thread in threads:
		thread.wait_to_finish()
	
	print("all threads finished")
	print(images)
	var final = combine_chunks()
	final.save_png("final.png")
	texture_image = final


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (texture_image != null): texture = ImageTexture.create_from_image(texture_image)
	#if (new_image_ready):
		#if (result == null):
			#result = image
		#else:
			#result = blend_images(result, image)
		#result.save_png("render.png")
		#texture = ImageTexture.create_from_image(result)
		#current_sample += 1
		#start_render_thread()

func start_render_thread():
	new_image_ready = false;
	
	thread = Thread.new()
	thread.start(render.bind())

func render():
	var world = setup_world()
	var cam = setup_camera()
	
	var n: int = sqrt(thread_count)
	var chunk_width = int(image_width / n)
	var chunk_height = int(image_height / n)
	
	var coordinates = []
	
	for i in range(n):
		for j in range(n):
			var start = Vector2(i * chunk_width, j * chunk_height)
			var end = Vector2((i + 1) * chunk_width, (j + 1) * chunk_height)
			
			# makes the right and bottom chunks slightly larger to correct
			# for inaccuracies through integer divison
			if i == n - 1: end.x = image_width
			if j == n - 1: end.y = image_height
			
			coordinates.append(start)
			coordinates.append(end)
	
	print(coordinates)
	
	for i in range(thread_count):
		var copy_of_cam: RenderCamera = cam.get_copy()
		copy_of_cam.camera_id = i
		copy_of_cam.chunk_start = coordinates[i * 2]
		copy_of_cam.chunk_end = coordinates[i * 2 + 1]
		
		threads[i].start(render_chunk.bind(i, copy_of_cam, world))


func render_chunk(id: int, cam: RenderCamera, world: HittableList):
	var i: Image = cam.render(world)
	i.save_png("render" + str(id) + ".png")
	images[id] = i
	print("finished thread " + str(id))


func combine_chunks() -> Image:
	var final = Image.new()
	final = Image.create(image_width, image_height, false, Image.FORMAT_RGBA8)
	
	var n: int = sqrt(thread_count)
	var chunk_width = int(image_width / n)
	var chunk_height = int(image_height / n)
	
	for x in range(image_width):
		for y in range(image_height):
			var row = min(int(x / chunk_width), n - 1)
			var column = min(int(y / chunk_height), n - 1)
			var index = row * n + column
			
			var color = images[index].get_pixel(x, y)
			final.set_pixel(x, y, color)
			
	return final

func setup_world() -> HittableList:
	var world = HittableList.new()
	
	var material_ground = LambertianMaterial.new(Color(0.8, 0.8, 0.0))
	var material_center = LambertianMaterial.new(Color(0.1, 0.2, 0.5))
	var material_left = DielectricMaterial.new(1.5)
	var material_bubble = DielectricMaterial.new(1.0 / 1.5)
	var material_right = MetalMaterial.new(Color(0.6, 0.6, 0.2), 1.0)
	
	world.add(Sphere.new(Vector3(0, -100.5, -1), 100, material_ground))
	world.add(Sphere.new(Vector3(0, 0, -1.2), 0.5, material_center))
	world.add(Sphere.new(Vector3(-1.0, 0, -1), 0.5, material_left))
	world.add(Sphere.new(Vector3(-1.0, 0, -1), 0.4, material_bubble))
	world.add(Sphere.new(Vector3(1.0, 0, -1), 0.5, material_right))
	
	return world


func setup_camera() -> RenderCamera:
	var cam = RenderCamera.new()
	cam.image_width = image_width
	cam.image_height = image_height
	cam.samples_per_pixel = 64
	cam.max_ray_bounces = 8
	
	cam.vfov = 20
	cam.look_from = Vector3(-2,2,1)
	cam.look_at = Vector3(0,0,-1)
	cam.vup = Vector3(0,1,0)
	
	cam.defocus_angle = 10.0
	cam.focus_dist = 3.4
	
	return cam


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
