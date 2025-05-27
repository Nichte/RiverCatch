extends Control

func _ready() -> void:
	get_tree().paused = false
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fishing_suika.tscn")

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
