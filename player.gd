extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false

@export var SPEED = 100

@onready var animation_tree : AnimationTree = $AnimationTree

var direction : Vector2 = Vector2.ZERO

func _ready():
	animation_tree.active = true

func _process(delta):
	update_animation_parameters()
	
func _physics_process(delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down"). normalized()
	enemy_attack()
	if health <= 0:
		player_alive = false
		health = 0
		print("Персонаж умер")
		self.queue_free()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO	
	move_and_slide()

func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true 
		animation_tree["parameters/conditions/is_moving"] = false
	else: 
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		
	if(Input.is_action_just_pressed("attacking")):
		animation_tree["parameters/conditions/attack"] = true
	else:
		animation_tree["parameters/conditions/attack"] = false
		
		
	if(direction != Vector2.ZERO):	
		animation_tree ["parameters/Idle/blend_position"] = direction
		animation_tree ["parameters/Attack/blend_position"] = direction
		animation_tree ["parameters/Run/blend_position"] = direction

func player():
	pass
	
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false 
		$attack_cooldown.start()
		print(health)
		print("-10hp")


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
