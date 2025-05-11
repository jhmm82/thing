extends Area2D

signal pickupcollected

var amount = 20
var DOT = load("res://Food.png")
var MEAT = load("res://Meat.png")
var SLASH = load("res://Untitled drawing (4).png")

func _on_FOOD_body_entered(body):
	emit_signal("pickupcollected", body, amount)
	queue_free()


func _on_Timer_timeout():
	queue_free()
