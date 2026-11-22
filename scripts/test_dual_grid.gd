# this is a test script, replace with world gen script
extends Node2D

@onready var renderer: DualGridManager = $DualGridManager

func _ready() -> void:
	var world := {}
	for x in 10:
		for y in 8:
			world[Vector2i(x, y)] = BiomeData.Biome.GRASS
	for x in range(3, 6):
		for y in range(2, 5):
			world[Vector2i(x, y)] = BiomeData.Biome.WHITE
	world[Vector2i(8, 6)] = BiomeData.Biome.RED
	renderer.render_world(world)

# claude-ov primer, kako nej bi world gen script uporablou dual grid (v glavnem samo klices render_world(world: Dictionary)):

#extends Node2D  # generator script, e.g. on a WorldGenerator node (rename TestDualGrid)
#
#@onready var dual_grid: DualGridManager = $DualGridManager
#
#func _ready() -> void:
	#var world := generate_world(randi())
	#dual_grid.render_world(world)
#
#func generate_world(seed_value: int) -> Dictionary:
	#var world := {}
	## ... noise/biome logic fills world[Vector2i(x, y)] = BiomeData.Biome.GRASS etc.
	#return world
