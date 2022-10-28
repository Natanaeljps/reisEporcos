extends Area2D

export(PackedScene) var target_scene

func _ready():
	pass
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !target_scene:
			print("Não há cenas nesta porta!")
			return
		if 	get_overlapping_bodies().size() > 0:
			$anim.play("opening")
			get_overlapping_bodies()[0].play_walk_in_animation()
			
func next_level():
	var ERR = get_tree().change_scene_to(target_scene)
	
	if ERR != OK:
		print("falha ao abrir porta da cena!")




	
