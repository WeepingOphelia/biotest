class_name mob extends Area2D

var initial_hunger: int
var hunger: int
var health: int
var speed: float
var affin: Dictionary
var mob_type: String
var diet: Array
var fecund: bool
var refractory_period = 10
var refract = 10

var velocity: Vector2
var wander_velocity

var hunger_check = 50

signal died(obj)
signal spawn(type, pos, stats)

func _ready():
	pass

func _process(delta):
	starve(delta)
	forage()
	if fecund:
		for obj in get_overlapping_areas():
			if obj.is_in_group("mob"):
				if obj.mob_type == mob_type and obj.fecund:
					reproduce(obj)
	var nearby = detect()
	if nearby:
		velocity = react(nearby)
	stay_in_bounds()
	if velocity == Vector2.ZERO:
		if wander_velocity:
			velocity = wander_velocity
		else:
			wander_velocity = wander()
			velocity = wander_velocity
	else:
		wander_velocity = false
	position += velocity * speed * delta

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
			if obj.food_type in diet:
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
	return reaction.normalized()

func recombine(f1, f2):
	var new_gene = f1 + f2 / 2
	var n = God.MUTX * new_gene
	new_gene += randf_range(-n, n)
	return new_gene

func reproduce(mate):
	hunger -= initial_hunger * .75
	mate.hunger -= mate.initial_hunger * .75
	var new_affin = {}
	for key in affin.keys():
		# Average parents' affinities and apply mutation
		var parent_value = mate.affin.get(key, 0)
		new_affin[key] = recombine(affin[key], parent_value)

	# Create new meep with inherited traits
	var new_stats = {
		"hunger" = initial_hunger,
		"speed" = recombine(speed, mate.speed),
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

func set_type(type):
	mob_type = type

func starve(delta):
	hunger_check -= delta * 10
	if hunger_check <= 0:
		hungry()
		hunger_check = 50
	refract += delta
	if hunger > initial_hunger * .5 && refract > refractory_period && mob_type != "ghost":
		fecund = true
	else:
		fecund = false

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
	velocity = velocity.limit_length(speed)  # Prevent runaway speeds

func take_damage(val):
	for i in range(val):
		hungry()

func wander():
	return Vector2.from_angle(deg_to_rad(randi_range(1, 360)))
