extends Node2D

var Meep = load("res://fauna/meep.tscn")
var Fox = load("res://fauna/fox.tscn")
var Ghost = load("res://fauna/ghost.tscn")
var Pancake = load("res://food/pancake.tscn")
var Tart = load("res://food/tart.tscn")
var Meatbone = load("res://food/meatbone.tscn")
var Plant = load("res://flora/tree.tscn")

var Mobs = []
var Foods = []
var Plants = []

var GoldenMeep = false

func _ready():
	initial_spawn()
	pass

func physics_process(delta):
	pass

func initial_spawn():
	
	
	# Spawn Initial Mobs
	for i in range(God.N_FOX):
		var pos = rand_pos(50, 50)
		spawn_mob("fox", pos, God.fox_stats)
	for i in range(God.N_MEEPS):
		var pos = rand_pos(50, 50)
		spawn_mob("meep", pos, God.meep_stats)
	for i in range(God.N_GHOSTS):
		var pos = rand_pos(50, 50)
		spawn_mob("ghost", pos, God.ghost_stats)
	
	# Spawn Initial Food
	
	
	for i in range(God.N_MEAT):
		var pos = rand_pos(50, 25)
		spawn_food("meatbone", pos)
	for i in range(God.N_PASTRY):
		var pos = rand_pos(25, 25)
		if randi() % 2 == 0:
			spawn_food("pancake", pos)
		else:
			spawn_food("tart", pos)
			
	# Spawn Initial Plants
	
	for i in range(God.N_TREES):
		var pos = rand_pos(100, 150)
		spawn_plants("plant", pos)

func rand_pos(x_offset: int, y_offset: int):
	var randx = randi_range(x_offset, God.SCREEN_X - x_offset)
	var randy = randi_range(y_offset, God.SCREEN_Y - y_offset)
	return Vector2(randx, randy)

func restore_pastries():
	for i in range(God.N_PASTRY):
		var pos = rand_pos(25, 25)
		if randi() % 2 == 0:
			spawn_food("pancake", pos)
		else:
			spawn_food("tart", pos)

func spawn_food(type, pos):
	var new_food
	match type:
		"meatbone":
			new_food = Meatbone.instantiate()
		"pancake":
			new_food = Pancake.instantiate()
		"tart":
			new_food = Tart.instantiate()
	new_food.position = pos
	new_food.scale = God.SCALE
	add_child(new_food)

func spawn_mob(type, pos, stats):
	var new_mob
	match type:
		"fox":
			new_mob = Fox.instantiate()
		"ghost":
			new_mob = Ghost.instantiate()
		"meep":
			new_mob = Meep.instantiate()
	new_mob.died.connect(death)
	new_mob.spawn.connect(spawn_mob)
	new_mob.position = pos
	new_mob.scale = God.SCALE
	new_mob.set_stats(stats)
	add_child(new_mob)
	if new_mob.mob_type == "meep" && !GoldenMeep:
		print("Golden Meep Selected")
		GoldenMeep = new_mob
		new_mob.modulate = Color(0.68, 0.61, 0.0, 1.0)
		new_mob.set_stat(true)
		
func spawn_plants(type, pos):
	var new_plant = Plant.instantiate()
	new_plant.position = pos
	new_plant.scale = God.SCALE
	add_child(new_plant)

func death(obj):
	if obj.mob_type != "ghost":
		spawn_food("meatbone", obj.position)
		spawn_mob("ghost", obj.position, God.ghost_stats)
	obj.queue_free()
