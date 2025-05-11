extends RigidBody2D

export var speed = 250

var boosting = false
onready var GAME = get_parent()
onready var charge = GAME.get_node("CanvasLayer/boostcharge")

onready var tlc = GAME.get_node("tlc")

func _physics_process(delta):
	rotate(get_angle_to(get_global_mouse_position())* 0.6)
	if position.distance_to(get_global_mouse_position()) > 70 and gravity_scale == 0:
		linear_velocity = Vector2.RIGHT.rotated(rotation) * speed
	elif gravity_scale == 0: linear_velocity = Vector2.ZERO
	if GAME.get_node("gravity").overlaps_body(self):
		gravity_scale = 5
	else: 
		gravity_scale = 0

var OLDPOS:Vector2

func _process(delta):
	charge.visible = charge.value > 0
	
	if charge.value >= charge.max_value: charge.get("custom_styles/fg").bg_color =  Color(0.2, 1, 0)
	else: charge.get("custom_styles/fg").bg_color = Color(1, 0.91, 0)
	
	tlc.modulate = lerp(tlc.modulate, Color(1, 1, 1, 1), 0.1)
	if !boosting: tlc.position = lerp(tlc.position, position, 0.3)
	else: tlc.position = lerp(tlc.position, position, 0.7)
		
	if Input.is_action_pressed("boost"):
		charge.value += 2
		
	if Input.is_action_just_released("boost"):
	#and position.distance_to(get_global_mouse_position()) > 70:
		if charge.value == charge.max_value:
			if GAME.PLAYERBOOST.x == 100: 
				GAME.PLAYERBOOST.x = 0
				boost(500)
				slash(4)
			elif GAME.PLAYERBOOST.y > 0: 
				GAME.PLAYERBOOST.y -= 1
				boost(500)
				slash(4)
				
		else:
			if GAME.PLAYERBOOST.x == 100: 
				GAME.PLAYERBOOST.x = 0
				boost(1100)
			elif GAME.PLAYERBOOST.y > 0: 
				GAME.PLAYERBOOST.y -= 1
				boost(1100)
		charge.value = -10

	if $Timer.time_left < 0.2 and $Timer.time_left > 0.01:
		speed /= 1.1

func slash(x):
	tlc.modulate = Color(1, 1, 1, 0)
	for _i in range(x):
		var thing = GAME.FOOD.instance()
		thing.get_node("Sprite").texture = thing.SLASH
		thing.amount = 0
		thing.position = global_position
		thing.get_node("Sprite").scale = Vector2(0.24,0.24) + Vector2(rand_range(-0.1,0),rand_range(-0.1,0))
		thing.get_node("CollisionShape2D").scale = Vector2(10,15)
		thing.get_node("Sprite").modulate = Color(1, 1, 1, 0.8)
		thing.rotation += rand_range(45, -45)
		thing.connect("pickupcollected", GAME, "_on_collected")
		GAME.add_child(thing)
		thing.get_node("Timer").start(0.13)
		position = position + Vector2.RIGHT.rotated(rotation) * 70
	
func boost(x):
	$Timer.start(0.28)
	boosting = true
	speed = x
	linear_velocity = Vector2.RIGHT.rotated(rotation) * speed

func _on_Timer_timeout():
	speed = 250
	$Timer/Timer2.start()

func _on_Timer2_timeout():
	boosting = false

func _on_damagebox_area_entered(area):
	speed = -250
	$Timer.start(0.28)
