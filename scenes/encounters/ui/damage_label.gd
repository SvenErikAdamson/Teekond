extends Label

func _ready():
	$AnimationPlayer.play("Pop")
	
func destroy():
	queue_free()
