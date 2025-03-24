extends MarginContainer

@onready var meepstats = $statblocks/meeps/statblock
@onready var foxstats = $statblocks/fox/statblock
@onready var ghoststats = $statblocks/ghost/statblock

const stat_template = "Avg FT:       {0} \n
Avg Speed:    {1} \n
Avg Affinities: \n
	Fox:      {2} \n
	Ghost:    {3} \n
	Meep:     {4} \n
	Pancake:  {5} \n
	Tart:     {6} \n
	Meatbone: {7}"

func _ready():
	pass
	
func _process(delta):
	set_mob_stats()
	
func showstats(state, mob_type):
	match mob_type:
		"meep":
			meepstats.visible = state
		"fox":
			foxstats.visible = state
		"ghost":
			ghoststats.visible = state

func set_mob_stats():
	var mobs = get_tree().get_nodes_in_group("mob")
	var mob_dict = {"meep": [], "fox": [], "ghost": []}
	var stat_dict = {}
	for n in mobs:
		mob_dict[n.mob_type].append(n)
	for mob_type in mob_dict.keys():
		stat_dict[mob_type] = get_stats(mob_dict[mob_type])
		
	$statblocks/meeps/count.text = "Meep: " + str(mob_dict["meep"].size())
	$statblocks/fox/count.text = "Fox: " + str(mob_dict["fox"].size())
	$statblocks/ghost/count.text = "Ghost: " + str(mob_dict["ghost"].size())
	
	meepstats.text = stat_dict["meep"]
	foxstats.text = stat_dict["fox"]
	ghoststats.text = stat_dict["ghost"]
		
func get_stats(list):
	
	if list.size() == 0:
		return stat_template
	
	var n = list.size()
	var ft_avg = 0
	var sp_avg = 0
	var affin_avg = {}
	
	for item in list:
		ft_avg += item.fertility_threshold
		sp_avg += item.speed
		for key in item.affin.keys():
			if key in affin_avg:
				affin_avg[key] += item.affin[key]
			else:
				affin_avg[key] = item.affin[key]
	
	var stat_val = [
		ft_avg,
		sp_avg,
		affin_avg["fox"],
		affin_avg["ghost"],
		affin_avg["meep"],
		affin_avg["pancake"],
		affin_avg["tart"],
		affin_avg["meatbone"]
		]
	
	stat_val = stat_val.map(func(x): return snapped((x / n), .01))
		
	var stat_block = stat_template.format(stat_val)
	
	return stat_block
