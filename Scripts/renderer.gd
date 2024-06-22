extends TextureRect

var thread: Thread
var image: Image

# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	thread.start(render.bind())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (image != null):
		image.save_png("render.png")
		texture = ImageTexture.create_from_image(image)

func render():
	# world
	var world = HittableList.new()
	world.add(Sphere.new(Vector3(0, 0, -1), 0.5))
	world.add(Sphere.new(Vector3(0, -100.5, -1), 100))
	
	# init camera and render image
	var cam = RenderCamera.new()
	cam.image_width = 800
	cam.image_height = 600
	cam.samples_per_pixel = 1
	image = cam.render(world)

