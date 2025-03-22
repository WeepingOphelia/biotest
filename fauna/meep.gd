extends mob

func _ready():
	set_type("meep")
	diet = ["pancake", "tart"]

func _process(delta):
	super._process(delta)
	if $stat.visible:
		$stat.text = str(hunger)


func set_stat(status):
	$stat.visible = status
