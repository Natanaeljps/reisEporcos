extends Node2D


# Chamado quando o nó entra na árvore de cena pela primeira vez
func _ready():
	print(Global.door_name)
	
	# código para encontrar a porta:
	if Global.door_name:
		var door_node = find_node(Global.door_name)
		if door_node:
			$Player.global_position = door_node.global_position
