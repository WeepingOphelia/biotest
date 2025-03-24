extends mob

func _ready():
	set_type("meep")
	diet = ["pancake", "tart"]

func _process(delta):
	super._process(delta)
	if $stat.visible:
		$stat.text = str(hunger) + "||" + str(hunger >= initial_hunger * fertility_threshold) + "||" + str(fertility_threshold)

func set_stat(status):
	$stat.visible = status
