extends Label

var is_running = false
var start_time = 0
var elapsed_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = Time.get_ticks_msec()
	update_label()
	is_running = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_running:
		elapsed_time = Time.get_ticks_msec() - start_time
		update_label()
	
	if (Status.current_pixel_id >= Status.current_max_pixel):
		is_running = false

func update_label():
	elapsed_time = elapsed_time / 1000
	var hours = elapsed_time / 3600
	var minutes = (elapsed_time / 60) % 60
	var seconds = elapsed_time % 60
	text = "%02d:%02d:%02d" % [hours, minutes, seconds]
