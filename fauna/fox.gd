extends mob

func _ready():
	set_type("fox")
	diet = ["meatbone"]

func _process(delta):
	super._process(delta)
	$stat.text = str(hunger) + str(fecund)
	for obj in get_overlapping_areas():
		if obj.is_in_group("mob"):
			if obj.mob_type == "meep":
				obj.take_damage(2)
				obj.position += position.direction_to(obj.position) * 10
	
