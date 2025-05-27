extends Sprite2D

var hp := 5
var score := 0
var score_added := 0
var net_position_x : int
var spawn_rate_star: float = 1.0  # seconds between spawns
var spawn_rate_trash: float = 1.2  # seconds between spawns
var trash_points := 1
var star_points := -1
var miss_damage := 1

var STAR = preload("res://Scenes/star.tscn")
var TRASH = preload("res://Scenes/trash.tscn")

func _ready():	
	get_tree().paused = false
	%StarTimer.wait_time = spawn_rate_star
	%StarTimer.start()
	
	await get_tree().create_timer(0.5).timeout  # Wait 1 second
	%TrashTimer.wait_time = spawn_rate_trash
	%TrashTimer.start()

# ===
# === SCORED FUNCITONS ===
func _on_star_scored_positive() -> void:
	hp -= miss_damage
	%HPScore.text = str(hp)
	
	if hp <= 0:
		game_over()
	%DamgeSound.playing = true

func _on_trash_missed_trash() -> void:
	hp -= miss_damage
	%HPScore.text = str(hp)
	
	if hp <= 0:
		game_over()
	%DamgeSound.playing = true
	
func _on_trash_scored_negative() -> void:
	score += trash_points
	score_added += 1
	%ScoreCount.text = str(score)

# ===
# === TIMER FUNCTIONS === 
func _on_spawn_timer_timeout() -> void:
	var new_star = STAR.instantiate()
	add_child(new_star)
	new_star.net_position_x = %Net.position.x
	new_star.scored_positive.connect(_on_star_scored_positive) 
	
	if score > 10:
		await get_tree().create_timer(0.5).timeout  # Wait 1 second
		new_star = STAR.instantiate()
		add_child(new_star)
		new_star.net_position_x = %Net.position.x
		new_star.scored_positive.connect(_on_star_scored_positive) 

func _on_trash_timer_timeout() -> void:
	# speeding up star spawn
	if score_added > 4:
		if $TrashTimer.wait_time > 0.3:	
			%TrashTimer.wait_time -= 0.02
		
		%Net.position.x += 10
		score_added = 0
	
	var new_trash = TRASH.instantiate()
	add_child(new_trash)
	new_trash.net_position_x = %Net.position.x
	new_trash.scored_negative.connect(_on_trash_scored_negative) 
	new_trash.missed_trash.connect(_on_trash_missed_trash)
	
# ==
# == OTHER FNCTIONS
func game_over():
	if score > Global.max_score:
		Global.max_score = score
		
	%DamgeSound.volume_db = 5
	%DamgeSound.playing = true

	%GameOver/DeathScreen/ReachedScore.text = "Score: " + str(score)
	%GameOver/DeathScreen/MaxScore.text = "Max score: " + str(Global.max_score)
	%GameOver.visible = true
	get_tree().paused = true
 
	
