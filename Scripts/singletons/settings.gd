extends Node

# General settings
var s: float = 6
var image_width: int = int(750 / s)
var image_height: int = int(500 / s)
var samples_per_pixel: int = 1
var max_ray_bounces: int = 5
var thread_count: int = 4 # has to be a perfect square!

# Camera settings
var vfov: float = 45
var look_from: Vector3 = Vector3(-6,12,6)
var look_at: Vector3 = Vector3(0,0,0)
var vup: Vector3 = Vector3(0,1,0)
var defocus_angle: float = 0
var focus_dist:float = 10.0
