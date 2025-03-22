extends mob

var absorb_tick = 0

func _ready():
	set_type("ghost")

func _process(delta):
	super._process(delta)
	var nearby = detect()
	if nearby:
		velocity = react(nearby)
	absorb_tick += delta
	if absorb_tick > 10:
		absorb()
		absorb_tick = 0
	position += velocity * speed * delta

func absorb():
	for obj in $leech.get_overlapping_areas():
		if obj.is_in_group("mob"):
			if obj.mob_type in ["meep", "fox"]:
				obj.take_damage(2)
				hunger += 1
				print("absorbed health")
