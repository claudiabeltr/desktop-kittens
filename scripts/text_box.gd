extends Sprite2D

@export var velocidad: float = 20.0  # píxeles por segundo

var limite_superior: float = 141.0
var limite_inferior: float = 162.0
var direccion: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += direccion * velocidad * delta
	
	if position.y >= limite_inferior:
		position.y = limite_inferior
		direccion = -1
	elif position.y <= limite_superior:
		position.y = limite_superior
		direccion = 1
