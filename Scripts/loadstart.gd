extends Button

@onready var sound =  $"../../../AudioStreamPlayer2D2"
@onready var timer = $"../../../Timer"

func _on_pressed() -> void:
	sound.play()
	timer.start()


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Levels/main.tscn")
