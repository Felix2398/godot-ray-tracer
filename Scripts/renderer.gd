extends TextureRect


var texture_image: Image
var images = []
var threads = []


func _ready():
	# Initialize values for the status singleton
	for i in range(Settings.thread_count):
		Status.current_pixel_ids.append(0)
	
	# Run as thread so the progress bar and time can also be displayed
	var thread = Thread.new()
	thread.start(run.bind())


func run():
	for i in range(Settings.thread_count):
		images.append(null)
		var thread = Thread.new()
		threads.append(thread)
	
	create_chunks()
	
	for thread in threads:
		thread.wait_to_finish()
	print("all threads finished")

	var render = combine_chunks()
	render.save_png("render.png")
	texture_image = render


# Waits until the image is rendered and displays it as texture
func _process(_delta):
	if (texture_image != null): texture = ImageTexture.create_from_image(texture_image)


# Creates chunks of the image and a thread and camera for each chunk
func create_chunks():
	var image_width = Settings.image_width
	var image_height = Settings.image_height
	var world = World.get_world()
	var cam = RenderCamera.new()
	
	print(str(image_width) + "x" + str(image_height))
	
	var n: int = sqrt(Settings.thread_count)
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
	
	for i in range(Settings.thread_count):
		var copy_of_cam: RenderCamera = cam.get_copy()
		copy_of_cam.camera_id = i
		copy_of_cam.chunk_start = coordinates[i * 2]
		copy_of_cam.chunk_end = coordinates[i * 2 + 1]
		
		threads[i].start(render_chunk.bind(i, copy_of_cam, world))


# Render each chunk of the image
func render_chunk(id: int, cam: RenderCamera, world: HittableList):
	var i: Image = cam.render(world)
	images[id] = i
	print("finished thread " + str(id))


# When all chunks are rendered, combine them to get the whole image
func combine_chunks() -> Image:
	var image_width = Settings.image_width
	var image_height = Settings.image_height
	var final = Image.new()
	
	final = Image.create(image_width, image_height, false, Image.FORMAT_RGBA8)
	
	var n: int = sqrt(Settings.thread_count)
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


# Calculates the weighted average image from to images
func blend_images(image1: Image, image2: Image, current_sample: int) -> Image:
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
