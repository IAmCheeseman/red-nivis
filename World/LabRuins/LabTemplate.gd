extends Node2D

export(float, 0, 1) var rarity = 1.0

onready var bg = $LabBackground
onready var solids = $LabSolids
onready var platforms = $OneWayPlatforms
onready var props = $Props
onready var containers = $Containers
