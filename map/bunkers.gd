extends Node2D

@onready var spawnBunker = self.get_node("SpawnBunker")
@onready var fortFooba = self.get_node("SpawnBunker")

func _on_spawn_bunker_body_entered(body: Node2D) -> void:
	if(body.get_name()=="Player"):
		global.ogygen_depletion_speed=-10
		print(global.ogygen_depletion_speed)


func _on_spawn_bunker_body_exited(body: Node2D) -> void:
	if(body.get_name()=="Player"):
		global.ogygen_depletion_speed=3
