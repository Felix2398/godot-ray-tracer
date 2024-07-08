extends Node


static func get_world() -> HittableList:
	var world = HittableList.new()
	
	var x = -1
	var y = 0
	var z = -5
	var radius = 0.5
	
	var ground = LambertianMaterial.new(Color(0.2, 0.2, 0.2))
	world.add(MyPlane.new(Vector3(0, -radius, 0), Vector3(0, 1, 0), ground))
	
	
	var body_color = Color(1.0, 0.0, 0.0)
	var light_color = Color(1.0, 0.1, 0.1)
	var shadow_color = Color(0.5, 0.0, 0.0)
	var highlight_color = Color(1.0, 0.2, 0.2)
	var stem_color = Color(1.0, 0.5, 0.1)
	var leaf_color = Color(0.0, 1.0, 0.0)
	var leaf_shadow_color = Color(0.0, 0.5, 0.0)
	
	var body = MetalMaterial.new(body_color, 0.5)
	var light = MetalMaterial.new(light_color, 0.25)
	var shadow = MetalMaterial.new(shadow_color, 0.75)
	var highlight = MetalMaterial.new(highlight_color, 0.1)
	var stem = MetalMaterial.new(stem_color, 0.5)
	var leaf = MetalMaterial.new(leaf_color, 0.5)
	var leaf_shadow = MetalMaterial.new(leaf_shadow_color, 0.75)
	
	world.add(Sphere.new(Vector3(x - 3, 0, z + 2), radius, body))
	
	world.add(Sphere.new(Vector3(x + 3, 0, z), radius, stem))
	world.add(Sphere.new(Vector3(x + 6, 0, z), radius, leaf_shadow))
	world.add(Sphere.new(Vector3(x + 7, 0, z), radius, leaf_shadow))
	
	world.add(Sphere.new(Vector3(x + 3, 0, z + 1), radius, stem))
	world.add(Sphere.new(Vector3(x + 4, 0, z + 1), radius, stem))
	world.add(Sphere.new(Vector3(x + 5, 0, z + 1), radius, leaf_shadow))
	world.add(Sphere.new(Vector3(x + 6, 0, z + 1), radius, leaf_shadow))
	world.add(Sphere.new(Vector3(x + 7, 0, z + 1), radius, leaf))
	
	world.add(Sphere.new(Vector3(x + 4, 0, z + 2), radius, stem))
	world.add(Sphere.new(Vector3(x + 5, 0, z + 2), radius, leaf))
	world.add(Sphere.new(Vector3(x + 6, 0, z + 2), radius, leaf))
	
	world.add(Sphere.new(Vector3(x + 1, 0, z + 3), radius, body))
	world.add(Sphere.new(Vector3(x + 2, 0, z + 3), radius, body))
	world.add(Sphere.new(Vector3(x + 3, 0, z + 3), radius, body))
	world.add(Sphere.new(Vector3(x + 4, 0, z + 3), radius, stem))
	world.add(Sphere.new(Vector3(x + 5, 0, z + 3), radius, shadow))
	world.add(Sphere.new(Vector3(x + 6, 0, z + 3), radius, light))
	world.add(Sphere.new(Vector3(x + 7, 0, z + 3), radius, body))
	
	world.add(Sphere.new(Vector3(x + 0, 0, z + 4), radius, light))
	world.add(Sphere.new(Vector3(x + 1, 0, z + 4), radius, body))
	world.add(Sphere.new(Vector3(x + 2, 0, z + 4), radius, body))
	world.add(Sphere.new(Vector3(x + 3, 0, z + 4), radius, light))
	world.add(Sphere.new(Vector3(x + 4, 0, z + 4), radius, light))
	world.add(Sphere.new(Vector3(x + 5, 0, z + 4), radius, light))
	world.add(Sphere.new(Vector3(x + 6, 0, z + 4), radius, body))
	world.add(Sphere.new(Vector3(x + 7, 0, z + 4), radius, body))
	world.add(Sphere.new(Vector3(x + 8, 0, z + 4), radius, body))
	
	world.add(Sphere.new(Vector3(x + 0, 0, z + 5), radius, light))
	world.add(Sphere.new(Vector3(x + 1, 0, z + 5), radius, body))
	world.add(Sphere.new(Vector3(x + 2, 0, z + 5), radius, body))
	world.add(Sphere.new(Vector3(x + 3, 0, z + 5), radius, body))
	world.add(Sphere.new(Vector3(x + 4, 0, z + 5), radius, body))
	world.add(Sphere.new(Vector3(x + 5, 0, z + 5), radius, body))
	world.add(Sphere.new(Vector3(x + 6, 0, z + 5), radius, highlight))
	world.add(Sphere.new(Vector3(x + 7, 0, z + 5), radius, highlight))
	world.add(Sphere.new(Vector3(x + 8, 0, z + 5), radius, body))
	
	world.add(Sphere.new(Vector3(x + 0, 0, z + 6), radius, light))
	world.add(Sphere.new(Vector3(x + 1, 0, z + 6), radius, body))
	world.add(Sphere.new(Vector3(x + 2, 0, z + 6), radius, body))
	world.add(Sphere.new(Vector3(x + 3, 0, z + 6), radius, body))
	world.add(Sphere.new(Vector3(x + 4, 0, z + 6), radius, body))
	world.add(Sphere.new(Vector3(x + 5, 0, z + 6), radius, body))
	world.add(Sphere.new(Vector3(x + 6, 0, z + 6), radius, highlight))
	world.add(Sphere.new(Vector3(x + 7, 0, z + 6), radius, highlight))
	world.add(Sphere.new(Vector3(x + 8, 0, z + 6), radius, body))
	
	world.add(Sphere.new(Vector3(x + 0, 0, z + 7), radius, light))
	world.add(Sphere.new(Vector3(x + 1, 0, z + 7), radius, body))
	world.add(Sphere.new(Vector3(x + 2, 0, z + 7), radius, shadow))
	world.add(Sphere.new(Vector3(x + 3, 0, z + 7), radius, shadow))
	world.add(Sphere.new(Vector3(x + 4, 0, z + 7), radius, body))
	# world.add(Sphere.new(Vector3(x + 5, 0, z + 7), radius, body))
	world.add(Sphere.new(Vector3(x + 6, 0, z + 7), radius, body))
	world.add(Sphere.new(Vector3(x + 7, 0, z + 7), radius, body))
	world.add(Sphere.new(Vector3(x + 8, 0, z + 7), radius, body))
	
	world.add(Sphere.new(Vector3(x + 0, 0, z + 8), radius, light))
	world.add(Sphere.new(Vector3(x + 1, 0, z + 8), radius, shadow))
	world.add(Sphere.new(Vector3(x + 2, 0, z + 8), radius, shadow))
	world.add(Sphere.new(Vector3(x + 3, 0, z + 8), radius, shadow))
	world.add(Sphere.new(Vector3(x + 4, 0, z + 8), radius, shadow))
	world.add(Sphere.new(Vector3(x + 5, 0, z + 8), radius, body))
	world.add(Sphere.new(Vector3(x + 6, 0, z + 8), radius, highlight))
	world.add(Sphere.new(Vector3(x + 7, 0, z + 8), radius, highlight))
	world.add(Sphere.new(Vector3(x + 8, 0, z + 8), radius, body))
	
	world.add(Sphere.new(Vector3(x + 1, 0, z + 9), radius, light))
	world.add(Sphere.new(Vector3(x + 2, 0, z + 9), radius, shadow))
	world.add(Sphere.new(Vector3(x + 3, 0, z + 9), radius, shadow))
	world.add(Sphere.new(Vector3(x + 4, 0, z + 9), radius, shadow))
	world.add(Sphere.new(Vector3(x + 5, 0, z + 9), radius, body))
	world.add(Sphere.new(Vector3(x + 6, 0, z + 9), radius, body))
	world.add(Sphere.new(Vector3(x + 7, 0, z + 9), radius, body))
	
	world.add(Sphere.new(Vector3(x + 2, 0, z + 10), radius, shadow))
	world.add(Sphere.new(Vector3(x + 3, 0, z + 10), radius, shadow))
	world.add(Sphere.new(Vector3(x + 4, 0, z + 10), radius, shadow))
	world.add(Sphere.new(Vector3(x + 5, 0, z + 10), radius, shadow))
	world.add(Sphere.new(Vector3(x + 6, 0, z + 10), radius, shadow))
	
	return world
