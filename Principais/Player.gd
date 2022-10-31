extends KinematicBody2D

var velocity = Vector2()

var current_state := 4
enum {RUN, ATTACK, JUMP, FALL, IDLE, HIT, DEAD}
var health = 3
var enter_state = true
var hitten = false



func _physics_process(delta):
	match current_state:
		RUN:
			_run_state(delta)
		ATTACK:
			_attack_state(delta)
		JUMP:
			_jump_state(delta)
		FALL:
			_fall_state(delta)
		IDLE:
			_idle_state(delta)
		HIT:
			_hit_state(delta)
		DEAD:
			pass
			
#STATE FUNCTION
func _run_state(_delta):
	$anim.play("run")
	_move()
	_apply_gravity(_delta)
	_move_and_slide()
	_set_state(_check_run_state())
	
func _attack_state(_delta):
	$anim.play("attack")
	_apply_gravity(_delta)
	velocity.x = 0
	_move_and_slide()

func _jump_state(_delta):
	if enter_state:
		$anim.play("jump")
		velocity.y = -350
		enter_state = false
		
	_apply_gravity(_delta)
	_move()
	_move_and_slide()
	_set_state(_check_jump_state())

func _fall_state(_delta):
	$anim.play("fall")
	_apply_gravity(_delta)
	_move()
	_move_and_slide()
	_set_state(_check_fall_state())

func _idle_state(_delta):
	$anim.play("idle")
	_apply_gravity(_delta)
	velocity.x = 0
	_move_and_slide()
	_set_state(_check_idle_state())

func _hit_state(_delta):
	$anim.play("hit")
	
#CHECK FUNCION
func _check_idle_state():
	var new_state = current_state
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		new_state = RUN
	elif Input.is_action_pressed("attack"):
		new_state = ATTACK
	elif Input.is_action_pressed("jump"):
		new_state = JUMP
	elif not is_on_floor():
		new_state = FALL
	return new_state

func _check_run_state():
	var new_state = current_state
	if (not Input.is_action_pressed("move_left")) and (not Input.is_action_pressed("move_right")):
		new_state = IDLE
	elif Input.is_action_pressed("attack"):
		new_state = ATTACK
	elif Input.is_action_pressed("jump"):
		new_state = JUMP
	elif not is_on_floor():
		new_state = FALL
	return new_state

func _check_jump_state():
	var new_state = current_state
	if velocity.y >= 0:
		new_state = FALL
	if Input.is_action_pressed("attack"):
		new_state = ATTACK
	return new_state	

func _check_fall_state():
	var new_state = current_state
	if is_on_floor():
		new_state = IDLE
	elif Input.is_action_pressed("attack"):
		new_state = ATTACK
	return new_state

func _check_hit_state():
	if hitten == true:
		velocity.x = 0
		$anim.stop(true)
	yield (get_tree().create_timer(.3), "timeout")
	$anim.play("hit")
		


#HELPERS	
func _apply_gravity(_delta):
	velocity.y += 800 * _delta
	
func _move_and_slide():
	velocity = move_and_slide(velocity, Vector2.UP)

func _move():
	if Input.is_action_pressed("move_left"):
		velocity.x = -100
#		$texture.flip_h = true
		$texture.scale.x = -1
	elif Input.is_action_pressed("move_right"):
		velocity.x = 100
#		$texture.flip_h = false
		$texture.scale.x = 1

func _set_state(new_state):
	if new_state != current_state:
		enter_state = true
	current_state = new_state 

#========Global e Sinais=========
func play_walk_in_animation():
	velocity.x = 0
	$anim.play("Door_in")

func _on_anim_animation_finished(anim_name):
	if anim_name  == "attack":
		_set_state(IDLE)

func _on_hammer_hit_area_entered(area):
	print("Toma Martelada!!!")


func _on_Hutbox_area_entered(area):
	hitten == true
	health -= 1
	yield (get_tree().create_timer(.2), "timeout")
	hitten == false
	if health < 1:
		$anim.play("death")
		yield (get_tree().create_timer(.3), "timeout")
#		queue_free()
