extends KinematicBody2D


enum { IDLE, RUN, ATTACK, HIT, DEATH}

const SPEED := 50
const DIST_FOLLOW := 100
const DIST_ATTACK := 30

var distance := 0.0
var strong := 10
var animation := ""
var state = 0
var direction := 1
var death := false
var velocity = Vector2.ZERO
var gravity = 1

var health := 3
var hitten = false

onready var anim = $anim
onready var player = $"../Player"

func _physics_process(_delta):
	distance = global_position.distance_to(player.global_position)
	velocity.y += gravity
	velocity.x = direction * SPEED

	match state:
		IDLE:
			_set_animation("idle")
			_hit()
			_dist_follow()
		RUN:
			_set_animation('run')
			_hit()
			_flip()
			move_and_slide(velocity)
			_give_up()
			_dist_attack()
		ATTACK:
			_set_animation("attack")
			_hit()
			yield (get_tree().create_timer(.6), "timeout")
			_enter_state(IDLE)
			return
		HIT:
			if hitten == true:
				_set_animation("hit")
		
		DEATH:
			if health < 1:
				_set_animation("death")

#STATE FUNCTION

#CHECK FUNCION

#HELPERS
func _enter_state(new_state):
	if state != new_state:
		state = new_state
		
func _set_animation(anim):
	if animation != anim:
		animation = anim
		$anim.play(animation)

func _flip():
	if global_position.x < player.global_position.x:
		$texture.scale.x = -1
		direction = 1

	elif global_position.x > player.global_position.x:
		$texture.scale.x = 1
		direction = -1

func _hit():
	if hitten == true:
		$anim.stop(true)
		velocity.x = 0

func _dist_follow():
	if distance <= DIST_FOLLOW:
		_enter_state(RUN)

func _give_up():
	if distance >= DIST_FOLLOW:
		_enter_state(IDLE)

func _dist_attack():
	if distance <= DIST_ATTACK:
		_enter_state(ATTACK)



func _on_Hitbox_area_exited(area):
	$anim.stop(true)
	yield (get_tree().create_timer(.3), "timeout")
	$anim.play("hit")
	hitten == true
	health -= 1
	yield (get_tree().create_timer(.2), "timeout")
	hitten == false
	if health < 1:
		$anim.play("death")
		yield (get_tree().create_timer(.3), "timeout")
		queue_free()



func _on_Area2D_area_entered(area):
	print("Pig Soco!!!!!")
