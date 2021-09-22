extends Node2D
class_name MoneyDropper

export var moneyRange:Vector2 = Vector2(2, 5)
export var valueRange:Vector2 = Vector2(1, 5)

var money = preload("res://Items/Money/Money.tscn")


func drop_money():
	for m in rand_range(moneyRange.x, moneyRange.y):
		var newMoney = money.instance()
		newMoney.global_position = global_position
		newMoney.value = int(round(rand_range(valueRange.x, valueRange.y)))
		GameManager.spawnManager.spawn_object(newMoney)
