extends Control

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		if $PauseMenu.is_visible():
			$PauseMenu.hide()
			get_tree().paused = false
		else:
			$PauseMenu.show()
			get_tree().paused = true

func _on_ResumeButton_pressed() -> void:
	$PauseMenu.hide()
	get_tree().paused = false
