extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_idle_animation: Timer = $TimerIdleAnimation
@onready var timer_5m: Timer = $Timer_5m

#Custom enumerate for state machine states
enum State { IDLE, PETTING, SLEEP }

var sleepiness
var state

# run idle animation flag 
var run_idle_animation = false

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
	
	#Switch
	match state:
		State.IDLE:
			if(run_idle_animation == true):
				run_idle_animation = false
				sprite.play("idle")
		State.PETTING:
			pass
		State.SLEEP:
			pass


# This function is called when it is time to run the idle animation
func _on_timer_idle_animation_timeout() -> void:
	run_idle_animation = true
	
