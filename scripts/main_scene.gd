extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_idle_animation: Timer = $TimerIdleAnimation
@onready var timer_sleep: Timer = $TimerSleep
@onready var timer_dialogue: Timer = $TimerDialogue

#Custom enumerate for state machine states
enum State { IDLE, PETTING, SLEEP }

var sleepiness
var state
var TOTAL_heart_count
var heart_count
const PETSPERHEART = 3
const MAXTOTALHEART = 11
var dialogues

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
	TOTAL_heart_count = 0
	heart_count = 0
	state = State.IDLE
	
	#Play idle animation at start
	sprite.play("idle")
	
	#Start 3s timer 
	timer_idle_animation.start()
	
	#Load dialogues from file
	load_dialogues()
	
	#Start dialogue timer
	timer_dialogue.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Switch
	match state:
		
		State.IDLE:
			# While on IDLE execute IDLE animation
			if(run_idle_animation == true):
				run_idle_animation = false
				_run_idle_animation(TOTAL_heart_count)
				
			# While on IDLE if button is pressed -> PETTING state
			if(run_petting_animation == true):
				run_petting_animation = false
				timer_sleep.stop() # Stop sleep timer while petting
				timer_idle_animation.stop()
				sprite.play("petting")
				state = State.PETTING
				
				if(TOTAL_heart_count < MAXTOTALHEART):
					heart_count += 1
					if(heart_count == PETSPERHEART):
						TOTAL_heart_count += 1
						heart_count = 0
					
				# !!!!!!!!!!!!!!!!!!!!!!!!
				print("corazones totales: " + str(TOTAL_heart_count) + " corazon actual " + str(heart_count))
				
			if(run_yawn_animation == true):
				run_yawn_animation = false
				sleepiness += 1
				if(sleepiness >= 3):
					sprite.play("sleepy")
					timer_sleep.stop() # Stop sleep timer while sleeping
					state = State.SLEEP
				else:		
					sprite.play("yawn")
				
		State.PETTING:
			# While on PETTING if button is unpressed -> IDLE state
			if(stop_petting_animation == true):
				stop_petting_animation = false
				sleepiness = 0 # After petting reset sleppiness
				timer_sleep.start() # Start timer again
				timer_idle_animation.start()
				sprite.play("idle")
				state = State.IDLE
				
		State.SLEEP:
			if(run_petting_animation == true):
				run_petting_animation = false
				sleepiness = 0
				timer_sleep.start() # Start timer again
				timer_idle_animation.start()
				sprite.play_backwards("sleepy") # new animation
				state = State.IDLE


# This function is called when it is time to run the idle animation
func _on_timer_idle_animation_timeout() -> void:
	run_idle_animation = true
	
func _on_button_button_down() -> void:
	run_petting_animation = true

func _on_button_button_up() -> void:
	stop_petting_animation = true

func _on_timer_sleep_timeout() -> void:
	run_yawn_animation = true
	
func _on_timer_dialogue_timeout() -> void:
	var probability_common = 99
	var dialogue_petting
	var probability_rare = 1
	
	var dialogues_common = dialogues["common"]
	var dialogues_rare = dialogues["rare"]
	
	var random = randf() * 100
	
	if(random <= probability_common):
		var random_number = randi_range(0, dialogues_common.size() - 1)
		print(dialogues_common[random_number])
	else:
		var random_number = randi_range(0, dialogues_rare.size() - 1)
		print(dialogues_rare[random_number])

# Runs an animation with probability based on the total_heart_counter
func _run_idle_animation(total_heart_counter) -> void:
	var probability_happy = 0
	var probability_glitch = 0
	
	var random = randf() * 100 #random number between 0 and 100
	
	if(total_heart_counter >= 5):
		probability_happy = 65 #65% to run happy animation when >= 5 total hearts
		
	if(total_heart_counter == 11):
		probability_glitch = 1 #1% probability to run glitch animation
	
	if(random <= probability_glitch):
		sprite.play("glitched")
	else:
		if(random <= probability_happy):
			sprite.play("happy")
		else:
			sprite.play("idle")

func load_dialogues():
	var file = FileAccess.open("res://assets/dialogue/dialogue.json", FileAccess.READ)
	if file == null:
		print("No se pudo abrir el archivo JSON")
		return
	var content = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(content)

	if error == OK:
		dialogues = json.get_data()
	else:
		print("Error al parsear JSON: ", json.get_error_message())
		
	
