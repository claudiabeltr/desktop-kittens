extends Label


@export var speed: float = 7.0  # pixels per second
var upper_limit: float = 229.0
var lower_limit: float = 233.0
var direction: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# The node smoothly moves up and down, between upper_limit and lower_limit,
# the child nodes (TextBox and DialogueText) move accordingly
func _process(delta: float) -> void:
	position.y += direction * speed * delta
	
	if position.y >= lower_limit:
		position.y = lower_limit
		direction = -1
	elif position.y <= upper_limit:
		position.y = upper_limit
		direction = 1
