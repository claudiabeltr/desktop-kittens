extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_idle_animation: Timer = $TimerIdleAnimation
@onready var timer_sleep: Timer = $TimerSleep
@onready var timer_dialogue: Timer = $TimerDialogue
@onready var dialogue_text: Label = $DialogueText
@onready var dialogue_textbox: Sprite2D = $TextBox

#Custom enumerate for state machine states
enum State { IDLE, PETTING, SLEEP }

# Sprite Frames directory for different skins
var skins: Dictionary = {
	"bombay": {
		"frames": preload("res://assets/sprites/frames/bombay_sprite_frames.tres"),
		"button": null, #the button is assigned in the _ready method, it needs to exist to get its reference
	},
	"calico": {
		"frames": preload("res://assets/sprites/frames/calico_sprite_frames.tres"),
		"button": null,
	},
	"siames": {
		"frames": preload("res://assets/sprites/frames/siames_sprite_frames.tres"),
		"button": null,
	},
	"orangecat": {
		"frames": preload("res://assets/sprites/frames/orangecat_sprite_frames.tres"),
		"button": null,
	},
	"angora": {
		"frames": preload("res://assets/sprites/frames/angora_sprite_frames.tres"),
		"button": null,
	},
}

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
	
	# Add buttons to dictionary
	skins["bombay"]["button"] = $CatMenu/BombayButton
	skins["calico"]["button"] = $CatMenu/CalicoButton
	skins["siames"]["button"] = $CatMenu/SiamesButton
	skins["orangecat"]["button"] = $CatMenu/OrangeCatButton
	skins["angora"]["button"] = $CatMenu/AngoraButton
	
	#Starting cat is BOMBAY
	set_skin("bombay")
	
	#Play idle animation at start
	sprite.play("idle")
	
	#Start 3s timer 
	timer_idle_animation.start()
	
	#Load dialogues from file
	load_dialogues()
	
	#Text and textbox are disabled by default
	dialogue_text.visible = false
	dialogue_textbox.visible = false
	
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
				
				# Dialogue
				var dialogues_petting = dialogues["petting"]
				var random_number = randi_range(0, dialogues_petting.size() - 1)
				dialogue_text.text = dialogues_petting[random_number]
				dialogue_text.visible = true
				dialogue_textbox.visible = true
				
				# !!!!!!!!!!!!!!!!!!!!!!!!
				print("corazones totales: " + str(TOTAL_heart_count) + " corazon actual " + str(heart_count))
				
			if(run_yawn_animation == true):
				run_yawn_animation = false
				sleepiness += 1
				if(sleepiness >= 3):
					sprite.play("sleepy")
					timer_sleep.stop() # Stop sleep timer while sleeping
					timer_idle_animation.stop()
					timer_dialogue.stop()
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
				
				dialogue_text.visible = false
				dialogue_textbox.visible = false
				
				
		State.SLEEP:
			if(run_petting_animation == true):
				run_petting_animation = false
				sleepiness = 0
				timer_sleep.start() # Start timer again
				timer_idle_animation.start()
				timer_dialogue.start()
				sprite.play_backwards("sleepy") # new animation
				state = State.IDLE


# This function is called when it is time to run the idle animation
func _on_timer_idle_animation_timeout() -> void:
	run_idle_animation = true
	
func _on_petbutton_button_down() -> void:
	run_petting_animation = true

func _on_petbutton_button_up() -> void:
	stop_petting_animation = true

func _on_timer_sleep_timeout() -> void:
	run_yawn_animation = true
	
func _on_timer_dialogue_timeout() -> void:
	var probability_common = 99
	var probability_rare = 1
	
	# "dialogues" contains ALL the dialogues, we need to get each tier phrases in a list
	var dialogues_common = dialogues["common"]
	var dialogues_rare = dialogues["rare"]
	
	var random = randf() * 100
	
	if(random <= probability_common):
		var random_number = randi_range(0, dialogues_common.size() - 1)
		dialogue_text.text = dialogues_common[random_number]
	else:
		var random_number = randi_range(0, dialogues_rare.size() - 1)
		dialogue_text.text = dialogues_rare[random_number]
		
	# Make text and text box both visible. 
	dialogue_text.visible = true
	dialogue_textbox.visible = true
	
	#Start timer to hide text after 10 seconds
	await get_tree().create_timer(10.0).timeout
	dialogue_text.visible = false
	dialogue_textbox.visible = false
	
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

# Load dialogues from JSON file. This JSON has the following structure:
# "Type" -> ["Dialogue 1", "Dialogue 2", "Dialogue 3"]
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
		
# This function changes the cat skin. It does so by changing it SpriteFrames,
# so a new SpriteFrames is required for each skin. It additionally manages the
# buttons that set the skins, leaving pressed only the button for the current skin
func set_skin(skin: String) -> void:
	sprite.set_sprite_frames(skins[skin]["frames"])
	for key in skins:
		if(key != skin):
			skins[key]["button"].button_pressed = false

func _on_calico_button_toggled(toggled_on: bool) -> void:
	if(toggled_on == true):
		set_skin("calico")

func _on_bombay_button_toggled(toggled_on: bool) -> void:
	if(toggled_on == true):
		set_skin("bombay")

func _on_siames_button_toggled(toggled_on: bool) -> void:
	if(toggled_on == true):
		set_skin("siames")

func _on_orangecat_button_toggled(toggled_on: bool) -> void:
	if(toggled_on == true):
		set_skin("orangecat")

func _on_angora_button_toggled(toggled_on: bool) -> void:
	if(toggled_on == true):
		set_skin("angora")
