extends Node

const AAH = preload("res://assets/sound/aaah.wav")
const EHAYLEA = preload("res://assets/sound/eyhaeyla.mp3")
const FOOTSTEP = preload("res://assets/sound/Footsteps_-_Plains.mp3")
const HORN = preload("res://assets/sound/horn.mp3")
const EYHA = preload("res://assets/sound/slavicwoman_eeeeyhi2.mp3")
const EHEE = preload("res://assets/sound/slavicwomen_eeeeheeeee.mp3")
const CLICK = preload("res://assets/sound/clicky_duDU.mp3")
const EAT = preload("res://assets/sound/eating.mp3")

const MINIGAME_CORRECT = preload("res://assets/sound/minigame/minigameyes.ogg")
const MINIGAME_FALSE = preload("res://assets/sound/minigame/minigameno.ogg")

##Tribe
const MELEE_HIT = preload("res://assets/sound/tribe/melee sound.wav")
const ANIMAL_HIT = preload("res://assets/sound/tribe/animal melee sound.wav")
@onready var audioplayers = $AudioPlayers

func play_sound(sound):
	for audiostreamplayer in audioplayers.get_children():
		if not audiostreamplayer.playing:
			audiostreamplayer.stream = sound
			audiostreamplayer.play()
			break
