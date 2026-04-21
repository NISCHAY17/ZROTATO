extends Node2D
class_name Unit
@export var stats: Unitstats
@onready var sprite: Sprite2D = %Sprite
@onready var visuals: Node2D = %Visuals
@onready var anim_player: AnimationPlayer = $AnimationPlayer
