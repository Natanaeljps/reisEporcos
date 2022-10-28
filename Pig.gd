extends KinematicBody2D

export var speed = 64
export var health = 1
var velocity = Vector2.ZERO
var gravity = 1200
var move_direction = -1

func _process(_delta):
	if $anim.current_animation == "attack":
		return

func _physics_process(delta):
	velocity.x = speed * move_direction
	velocity.y += gravity * delta
	
	if move_direction == 1:
		$texture.flip_h = true
	else:
		$texture.flip_h = false
		
	if $raycast.is_colliding():
		$anim.play("idle")
		$raycast.scale.x *= -1
		yield (get_tree().create_timer(1.5), "timeout")
		$anim.play("run")
		move_direction *= -1	

	velocity = move_and_slide(velocity)
	
	
func hit():
	$attackDetector.monitoring = true
	
func end_hit():
	$attackDetector.monitoring = false
	
func start_hit():
	$anim.play("run")

func _on_playerDetector_body_entered(_body):
	$anim.play("attack")

func _on_attackDetector_body_entered(_body):
	get_tree().reload_current_scene()
