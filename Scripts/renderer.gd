extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	print("start rendering")
	render()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func render():
	# world
	var world = HittableList.new()
	world.add(Sphere.new(Vector3(0, 0, -1), 0.5))
	world.add(Sphere.new(Vector3(0, -100.5, -1), 100))
	
	# init camera and render image
	var cam = RenderCamera.new()		
	var image = cam.render(world)
	image.save_png("render.png")
	texture = ImageTexture.create_from_image(image)
