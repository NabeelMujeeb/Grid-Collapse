extends OptionButton

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_item("Medium",0)
	self.add_item("Easy",1)
	self.add_item("Hard",2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
