extends Node2D

onready var pickUpArea = $PickUpArea
onready var gunLogic = $GunLogic
onready var pivot = $Pivot
onready var tooltips = $TooltipHolder/GunTooltips/Tooltips
onready var tooltipsAnim = $TooltipHolder/GunTooltips/AnimationPlayer
onready var tooltipHolder = $TooltipHolder
onready var shootSound = $ShootSound
