extends Node

const SCREEN_X = 1280
const SCREEN_Y = 720
const SCALE = Vector2(.5, .5)

const N_GHOSTS = 0
const N_MEEPS = 60
const N_FOX = 4
const N_TREES = 0
const N_PASTRY = 300
const N_MEAT = 100

const MUTX = .2
const MAX_SPEED = 500

const nutrition = {
	"meatbone": 3,
	"pancake": 1,
	"tart": 1
}

const fox_stats = {
	"hunger": 20,
	"speed": 50,
	"ft": 1.2,
	"sc": .5,
	"rp": 4,
	"affin": {
		"tree": 5,
		"ghost": 6,
		"meep": 25,
		"fox": 0,
		"meatbone": 50,
		"pancake": 0,
		"tart": 6
	}
}

const meep_stats = {
	"hunger": 10,
	"speed": 60,
	"ft": .5,
	"sc": .25,
	"rp": 2,
	"affin": {
		"tree": 0,
		"ghost": -1,
		"meep": 0,
		"fox": -12,
		"meatbone": 0,
		"pancake": 6,
		"tart": 1
	}
}

const ghost_stats = {
	"hunger": 5,
	"speed": 10,
	"ft": 0,
	"sc": 0,
	"rp": 0,
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
