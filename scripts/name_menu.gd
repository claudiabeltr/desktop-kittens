extends Control

const MAX_UI_HEARTS = 10

@onready var hearts: Array[TextureRect] = [
	$Heart0, $Heart1, $Heart2, $Heart3, $Heart4,
	$Heart5, $Heart6, $Heart7, $Heart8, $Heart9
]
#Heart 11 is a hidden feature!

@export var empty_texture: Texture2D = preload("res://textures/empty_heart.tres")
@export var full_texture: Texture2D = preload("res://textures/full_heart.tres")

var total_hearts = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(MAX_UI_HEARTS):
		if(total_hearts > i):
			hearts[i].texture = full_texture
		else:
			hearts[i].texture = empty_texture

# Setter function called by the father script to set the total hearts to be 
# shown in the UI
func set_total_hearts(hearts):
	total_hearts = hearts
