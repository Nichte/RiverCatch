extends Control

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/fishing_suika.tscn")

func _on_tutorial_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
