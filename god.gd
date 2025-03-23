extends Node

const SCREEN_X = 1280
const SCREEN_Y = 720
const SCALE = Vector2(.5, .5)

const N_GHOSTS = 0
const N_MEEPS = 25
const N_FOX = 2
const N_TREES = 0
const N_PASTRY = 250
const N_MEAT = 5

const MUTX = .2

const nutrition = {
	"meatbone": 2,
	"pancake": 1,
	"tart": 1
}

const fox_stats = {
	"hunger": 20,
	"speed": 50,
	"affin": {
		"tree": 5,
		"ghost": 6,
		"meep": 12,
		"fox": 0,
		"meatbone": 30,
		"pancake": 0,
		"tart": 6
	}
}

const meep_stats = {
	"hunger": 10,
	"speed": 100,
	"affin": {
		"tree": 0,
		"ghost": -1,
		"meep": -1,
		"fox": -12,
		"meatbone": 0,
		"pancake": 6,
		"tart": 1
	}
}

const ghost_stats = {
	"hunger": 5,
	"speed": 10,
	"affin": {
		"tree": 5,
		"ghost": 6,
		"meep": 12,
		"fox": 11,
		"meatbone": 10,
		"pancake": 6,
		"tart": 6
	}
}
