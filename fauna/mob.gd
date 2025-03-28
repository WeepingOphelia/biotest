class_name mob extends Area2D

var initial_hunger: int
var hunger: int
var health: int
var speed: float
var fertility_threshold: float
var spawn_cost: float
var affin: Dictionary
var mob_type: String
var diet: Array
var fecund: bool
var refractory_period: int
var refract: float

var velocity: Vector2
var moment: Vector2 = Vector2.ZERO
var wander_velocity

var hunger_check = 2
var reaction_time = .5

signal died(obj)
signal spawn(type, pos, stats)

func _ready():
	pass

func _process(delta):
	starve(delta)
	check_fecundity(delta)
	forage()
	if fecund:
		for obj in get_overlapping_areas():
			if obj.is_in_group("mob"):
				if obj.mob_type == mob_type and obj.fecund:
					reproduce(obj)
	reaction_time += delta
	if reaction_time >= .5:
		var nearby = detect()
		if nearby:
			velocity = react(nearby)
		reaction_time = 0
	stay_in_bounds()
	if velocity == Vector2.ZERO:
		velocity = wander().normalized()
	position += velocity * speed * delta

func check_fecundity(delta):
	refract += delta
	if hunger >= initial_hunger * fertility_threshold && refract >= refractory_period && mob_type != "ghost":
		fecund = true
	else:
		fecund = false

func detect():
	var nearby_objects = $vision.get_overlapping_areas()
	var nearby = {
		"meep": [],
		"fox": [],
		"ghost": [],
		"pancake": [],
		"tart": [],
		"meatbone": [],
		"tree": []
	}
	for obj in nearby_objects:
		if obj == self:
			continue
		if obj.is_in_group("mob"):
			nearby[obj.mob_type].append(obj)
		if obj.is_in_group("food"):
			nearby[obj.food_type].append(obj)
		if obj.is_in_group("plant"):
			nearby["tree"].append(obj)
	return nearby

func eat(food):
	hunger += God.nutrition[food.food_type]
	food.queue_free()

func forage():
	for obj in get_overlapping_areas():
		if obj.is_in_group("food"):
			if obj.food_type in diet && hunger < initial_hunger * 2:
				eat(obj)

func get_closest(list):
	var min_dist = INF
	var closest = null
	for obj in list:
		var dist = position.distance_to(obj.position)
		if dist < min_dist:
			closest = obj
			min_dist = dist
	return closest

func hungry():
	hunger -= 1
	if hunger <= 0:
		died.emit(self)

func react(objects):
	var reaction = Vector2(0, 0)
	for type in objects:
		var influence = Vector2(0, 0)
		for obj in objects[type]:
			var dir = position.direction_to(obj.position)
			var dis = max(position.distance_squared_to(obj.position), 1.0)
			influence += dir / dis * dis
		reaction += influence * affin[type]
	if reaction.length() < 0.1:
		return moment
	moment = ((reaction * .5) + (moment * .8)).normalized()
	return moment

func recombine(f1, f2):
	var new_gene = f1 + f2 / 2
	var n = God.MUTX * new_gene
	if n == 0:
		n = God.MUTX
	new_gene += randf_range(-n, n)
	return new_gene

func reproduce(mate):
	
	# Costs hunger
	hunger -= initial_hunger * spawn_cost
	mate.hunger -= mate.initial_hunger * spawn_cost
	
	# Recombine Affinities
	var new_affin = {}
	for key in affin.keys():
		# Average parents' affinities and apply mutation
		var parent_value = mate.affin.get(key, 0)
		new_affin[key] = recombine(affin[key], parent_value)

	# Create new meep with inherited traits
	var new_stats = {
		"hunger" = initial_hunger,
		"speed" = min(recombine(speed, mate.speed), God.MAX_SPEED),
		"ft" = min(recombine(fertility_threshold, mate.fertility_threshold), 2),
		"sc" = spawn_cost,
		"rp" = refractory_period,
		"affin" = new_affin
	}
	var new_pos = position + Vector2(randi_range(-10, 10), randi_range(-10, 10))
	spawn.emit(mob_type, new_pos, new_stats)
	fecund = false
	refract = 0

func set_stats(stats):
	initial_hunger = stats["hunger"]
	hunger = stats["hunger"]
	speed = stats["speed"]
	affin = stats["affin"]
	fertility_threshold = stats["ft"]
	spawn_cost = stats["sc"]
	refractory_period = stats["rp"]
	refract = refractory_period

func set_type(type):
	mob_type = type

func starve(delta):
	hunger_check -= delta
	if hunger_check <= 0:
		hungry()
		hunger_check = 1

func stay_in_bounds():
	var bounds_margin = 50
	var force = Vector2.ZERO

	if position.x > God.SCREEN_X - bounds_margin:
		force.x -= 5
	elif position.x < bounds_margin:
		force.x += 5

	if position.y > God.SCREEN_Y - bounds_margin:
		force.y -= 5
	elif position.y < bounds_margin:
		force.y += 5

	velocity += force
	velocity = velocity.normalized()

func take_damage(val):
	for i in range(val):
		hungry()

func wander():
	if wander_velocity == null || randf() < 0.01:  # Change direction rarely
		wander_velocity = Vector2.from_angle(randf_range(0, TAU))
	return wander_velocity
