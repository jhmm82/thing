extends Node2D
onready var QP = $CanvasLayer/ProgressBar

const FOOD:PackedScene = preload("res://food.tscn")
const EEL:PackedScene = preload("res://hitter.tscn")
var numFOOD = 0

var PLAYERBOOST = Vector2(0,0)

func _ready():
	for i in range(20): foodify()	
func _draw():
	draw_line(Vector2(-3000, 260), Vector2(5000, 260), Color.turquoise, 3)

func _process(delta):
	if QP.value >= 100: QP.get("custom_styles/fg").bg_color =  Color(0.2, 1, 0)
	else: QP.get("custom_styles/fg").bg_color = Color(0, 0.7, 1)
	QP.value = PLAYERBOOST.x
	
	if Input.is_action_pressed("cheat"): PLAYERBOOST.x = 100
	
	$CanvasLayer/three.visible = PLAYERBOOST.y > 2
	$CanvasLayer/two.visible = PLAYERBOOST.y > 1
	$CanvasLayer/one.visible = PLAYERBOOST.y > 0
	
	
	if Input.is_action_just_pressed("z"): 
		var thing = EEL.instance()
		add_child(thing)
		#thing.position = Vector2(rand_range(-130, 1300), rand_range(260, 600) )
		thing.position = get_global_mouse_position()

func _on_Timer_timeout():
	if numFOOD < 50:
		foodify()

func foodify():
	var thing = FOOD.instance()
	thing.connect("pickupcollected", self, "_on_collected")
	add_child(thing)
	thing.position = Vector2(rand_range(-130, 1300), rand_range(260, 600) )
	numFOOD += 1

func _on_collected(body, amount):
	if body == $Player:
		if PLAYERBOOST.x < 100: PLAYERBOOST.x += amount
	if body.has_method("EEL") and amount==0:
		body.bite()
	numFOOD -=1
