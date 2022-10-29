class_name CharacterBase extends KinematicBody2D

enum StateMachine {IDLE, RUN, JUMP, FALL, ATK}

export var speed := 100
export var jump_force:= 150
export var gravity:= 9.8

var state = StateMachine.IDLE
var motion := Vector2()
var animation := ""
var direction := 0
var enter_state := true

onready var sprite : Sprite = get_node("Sprite")
onready var animator : AnimationPlayer = get_node("AnimationPlayer")

func _process(delta):
	direction = Input.get_axis("move_right", "move_left")

func _physics_process(delta):
	motion = move_and_slide(motion, Vector2.UP)

func _move_and_slide(delta):
	motion.x = direction * speed

func _apply_gravity(delta):
	motion.y += gravity * delta

func _set_animaton(anim):
	if animation != anim:
		animation = anim
		animator.play(animation)