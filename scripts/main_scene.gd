extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_idle_animation: Timer = $TimerIdleAnimation
@onready var timer_5m: Timer = $Timer_5m

#Custom enumerate for state machine states
enum State { IDLE, PETTING, SLEEP }

var sleepiness
var state

func _ready() -> void:
	# Initialize variables
	sleepiness = 0
	state = State.IDLE
	
	#Play idle animation at start
	sprite.play("idle")
	
	#Start 3s timer 
	timer_idle_animation.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_idle_animation_timeout() -> void:
	if(state == State.IDLE):
		sprite.play("idle")
