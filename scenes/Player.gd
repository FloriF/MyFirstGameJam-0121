extends KinematicBody2D

############### VARIABLES AND CONSTANTS #################

# basic directions
const UP = Vector2(0, -1)

# movement
export var speed = 500
var velocity = Vector2(0, 0)

const JUMP_SPEED = 1500
const GRAVITY = 150

# mouse handling
var mouse_pos = Vector2(0, 0)

# projectiles
var projectileScene = load("res://scenes/Projectile.tscn")
var projectile_amount = 0

########################## DOING STUFF ########################


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(delta):
	# determine and apply current omnidirectional velocity to the player
	determine_velocity()
	move_and_slide(velocity, UP)
	
	# handle mouse input for shooting
	# get mouse position
	mouse_pos = get_global_mouse_position()
	# rotate ProjectileCenter
	self.look_at(mouse_pos)

	# spawn projectile
	if Input.is_action_just_pressed("shoot"):
		# instance in a projectile when clicking
		var projectile = load("res://scenes/Projectile.tscn").instance()
		$ProjectileSpawnLocation.add_child(projectile)
		# make the projectile not a child of the player and move with it, but as top level child
		projectile.set_as_toplevel(true)
		# count the number of projectiles in the scene
		projectile_amount += 1
		print(projectile_amount)
		


######################## HELPER: MOVEMENT ####################

# determine player movement
func determine_velocity():
	move()
	jump()
	apply_gravity()

# apply gravity to the player
func apply_gravity():
	if not is_on_floor():
		velocity.y += GRAVITY

# handle jumping
# extra function to enable jumping while walking
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_SPEED

# handles the player movement
func move():
	# apply speed to the pressed movement action to determine velocity 
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		velocity.x = - speed
	elif Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		velocity.x = speed
	else:
		velocity.x = 0

