extends Node

const SCREEN_X = 1280
const SCREEN_Y = 720
const SCALE = Vector2(.5, .5)

const N_GHOSTS = 5
const N_MEEPS = 20
const N_FOX = 0
const N_TREES = 0
const N_PASTRY = 40
const N_MEAT = 0

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
	"hunger": 5,
	"speed": 60,
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
	"health": 4,
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
