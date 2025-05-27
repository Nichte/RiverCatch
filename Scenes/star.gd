extends CharacterBody2D

signal scored_positive

var speed: float = 300
var direction: Vector2 = Vector2.LEFT
var has_scored: bool  
var is_small: bool
var net_position_x : int

func _ready() -> void:
	var viewport = get_viewport_rect().size
	position.x = 1150  # Right edge of screen
	position.y = randi_range(200, 528)  # Random Y position
	direction.y = randf_range(-1.0, 1.0)
	
	set_process_input(true)
	has_scored = false
	is_small = false
	
func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		direction.y *= -1
	
	# Check if star passed the scoring line (e.g., x=100) and hasn't scored yet
	if position.x < net_position_x + 10  and not has_scored:
		if is_small == false:
			has_scored = true  # Prevent duplicate scoring
			
			emit_signal("scored_positive")  # Notify main.gd
			queue_free()
		
	if position.x < -50:
		queue_free()

func _on_star_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Instantly shrink to 50% size (change 0.5 to any scale you want)
		scale = Vector2(0.5, 0.5)
		is_small = true
