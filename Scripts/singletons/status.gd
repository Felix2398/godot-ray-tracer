extends Node

var current_pixel_id: int
var current_max_pixel: int
var thread_coun
var current_pixel_ids = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var sum = 0
	for id in current_pixel_ids:
		sum += id
		
	current_pixel_id = sum
