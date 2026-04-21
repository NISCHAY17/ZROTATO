extends Unit

class_name Player

var move_dir: Vector2
#TIMERS
@export var dash_duration := 0.5
@export var dash_speed_multi := 2.67
@export var dash_cooldown := 1.67
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var dash_timer: Timer = $DashTimer
@onready var collision: CollisionShape2D = $CollisionShape2D

#var move_dir: Vector2 = Vector2.ZERO
var dash_dir: Vector2 = Vector2.ZERO
var is_dashing := false
var dash_available := true
func _ready() -> void:
	dash_timer.wait_time = dash_duration
	dash_cooldown_timer.wait_time = dash_cooldown
func _process(delta: float) -> void:
	var input_dir = Input.get_vector("move_left","move_right","move_up","move_down")

	if not is_dashing:
		move_dir = input_dir

	var current_velocity := move_dir * 500
	
	if is_dashing:
		current_velocity = dash_dir * 500 * dash_speed_multi
	
	position += current_velocity * delta
	
	if can_dash():
		start_dash()
	
	update_animation()
	update_rotation()
func update_animation() -> void:
	if move_dir.length() > 0:
		anim_player.play("move")
	else:
		anim_player.play("idle")
func update_rotation() -> void:
	if move_dir == Vector2.ZERO:
		return
	if move_dir.x >= 0.1:
		visuals.scale = Vector2(-0.5, 0.5)
	else:
		visuals.scale = Vector2(0.5, 0.5)
func start_dash() -> void:
	is_dashing = true
	dash_dir = move_dir.normalized()  # direction
	
	dash_timer.start()
	visuals.modulate.a = 0.5
	collision.set_deferred("disabled", true)
func can_dash() -> bool:
	return (
		not is_dashing
		and dash_cooldown_timer.is_stopped()
		and Input.is_action_just_pressed("dash")
		and move_dir != Vector2.ZERO
	)


func _on_dash_timer_timeout() -> void:
	is_dashing = false
	visuals.modulate.a = 1.0
	move_dir = Vector2.ZERO
	collision.set_deferred("disabled", false)
	dash_cooldown_timer.start()
