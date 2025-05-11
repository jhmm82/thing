extends RigidBody2D
onready var T = get_parent().get_node("TE")
onready var HB = get_parent().get_node("hb")

export var health = 700 setget hpSET

const FOOD:PackedScene = preload("res://food.tscn")

onready var GAME = get_parent().get_parent()

onready var SLASH = $Sprite2
var qqq = false

func EEL(): pass

func _ready():
	HB.max_value = health
	HB.value = health

func _process(delta):
	if get_tree().get_current_scene().get_node("gravity").overlaps_body(self):
		gravity_scale = 5
	else: 
		gravity_scale = 0
	T.position = position +Vector2(0,-80)
	HB.rect_position = position +Vector2(-25,-50)


func _on_Timer_timeout():
	T.visible = false

func hpSET(val):
	health = val
	HB.value = health
	if health <= 0:
		if T.visible and GAME.PLAYERBOOST.y < 3: 
			GAME.PLAYERBOOST.y += 1
			T.visible = false
		for i in range(9):
			var thing = FOOD.instance()
			thing.get_node("Sprite").texture = thing.MEAT
			thing.scale = Vector2(2,2)
			thing.rotation_degrees = 90
			thing.connect("pickupcollected", GAME, "_on_collected")
			thing.position = global_position + Vector2(rand_range(-25, 25), rand_range(-30, 60))
			GAME.call_deferred("add_child",thing)
		get_parent().queue_free()

func _on_hurtbox_area_entered(area):
	if area.get_parent().boosting == true:
		$Timer.start(2)
		T.visible = true
		hpSET(health -25)
	if T.visible and $short.time_left == 0: 
		hpSET(health -25)
		$Sprite2.rotation_degrees += 90
		$Sprite2.visible = true
		$short.start()
	hpSET(health -75)

func bite():
	if $Timer.time_left == 0:
		
		$Sprite2.rotation_degrees += 90
		$Sprite2.visible = true
		$short.start()
		
		$Timer.start(2)
		T.visible = true
		hpSET(health -100)
		if T.visible: hpSET(health-100)
		
func _on_short_timeout():
	$Sprite2.visible = false
