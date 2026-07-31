extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_idle_animation: Timer = $TimerIdleAnimation
@onready var timer_sleep: Timer = $TimerSleep

#Custom enumerate for state machine states
enum State { IDLE, PETTING, SLEEP }

var sleepiness
var state

# run idle animation flag 
var run_idle_animation = false
# run petting animation flag 
var run_petting_animation = false
# stop petting animation flag
var stop_petting_animation = false
# run yawn animation flag
var run_yawn_animation = false

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
			# While on IDLE execute IDLE animation
			if(run_idle_animation == true):
				run_idle_animation = false
				sprite.play("idle")
				
			# While on IDLE if button is pressed -> PETTING state
			if(run_petting_animation == true):
				run_petting_animation = false
				timer_sleep.stop() # Stop sleep timer while petting
				sprite.play("petting")
				state = State.PETTING
				
			if(run_yawn_animation == true):
				run_yawn_animation = false
				sleepiness += 1
				if(sleepiness >= 3):
					sprite.play("sleepy")
					state = State.SLEEP
				else:		
					sprite.play("yawn")
				
		State.PETTING:
			# While on PETTING if button is unpressed -> IDLE state
			if(stop_petting_animation == true):
				sleepiness = 0 # After petting reset sleppiness
				timer_sleep.start() # Start timer again
				stop_petting_animation = false
				sprite.play("idle")
				state = State.IDLE
				
		State.SLEEP:
			pass


# This function is called when it is time to run the idle animation
func _on_timer_idle_animation_timeout() -> void:
	run_idle_animation = true
	

func _on_button_button_down() -> void:
	run_petting_animation = true


func _on_button_button_up() -> void:
	stop_petting_animation = true


func _on_timer_sleep_timeout() -> void:
	run_yawn_animation = true
