extends Marker2D

# The length of the pendulum.
@export var length: float = 30
# Unrealistic gravity to artificially slow down the movement.
@export var gravity: float = 24  # 98
# Damping factor.
@export var damping: float = 0.995

# The current position of the pendulum's weight.
var weight_position: Vector2
# The current angle.
var angle: float
# Used to calculate the angular velocity.
var previous_global_position
# Used to calculate the angular velocity.
var angular_multiplier = 0.0003
# The current angular velocity.
var angular_velocity = 0.0


func _ready() -> void:
	previous_global_position = global_position
	weight_position = global_position + Vector2(length, 0)
	angle = Vector2.ZERO.angle_to(weight_position - global_position)
	angular_velocity = 0.0


func process_velocity(delta: float) -> void:
	# Add angular velocity based on x-excentricity.
	add_angular_velocity((previous_global_position.x - global_position.x) * angular_multiplier)
	# Calculate acceleration (see: http://www.myphysicslab.com/pendulum1.html)
	var angular_acceleration = ((-gravity * delta) / length) * sin(angle)
	# Update velocity.
	angular_velocity += angular_acceleration
	# Damping.
	angular_velocity *= damping
	# Update angle.
	angle += angular_velocity

	# Calculate the new position of the weight.
	var global_angle = angle + global_rotation
	weight_position = (
		global_position + Vector2(length * sin(global_angle), length * cos(global_angle))
	)

	# Store previous global position to add angular velocity in the next frame.
	previous_global_position = global_position


func add_angular_velocity(force: float) -> void:
	angular_velocity += force


func _physics_process(delta) -> void:
	process_velocity(delta)
