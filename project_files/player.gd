extends XROrigin3D

@export var move_speed: float = 2.5
@export var deadzone: float = 0.15
var snapturn_state: Vector2 = Vector2(0, 1)
var rotation2: float = 0
@onready var xr_camera: XRCamera3D = $XRCamera3D
@onready var left_ctrl: XRController3D = $LeftController
@onready var right_ctrl: XRController3D = $RightController

func _physics_process(delta: float) -> void:
	var dir := Vector3.ZERO

	var fwd := xr_camera.global_transform.basis.z; fwd.y = 0.0; fwd = fwd.normalized()
	var right := xr_camera.global_transform.basis.x; right.y = 0.0; right = right.normalized()


	var v: Vector2 = left_ctrl.get_vector2("thumbstick")
	if v.length() < deadzone:
		v = Vector2.ZERO

	dir += fwd * (-v.y) + right * (v.x)
	
	dir = dir.normalized().rotated(Vector3.UP, rotation2)

	if dir.length() > 0.0:
		transform.origin += (dir.normalized() * move_speed * delta)
		
	# Snapturn
	
	var v2: Vector2 = right_ctrl.get_vector2("thumbstick")
	if v2.length() < 0.5:
		snapturn_state = Vector2(0, 1)
		return
	
	var angle = snapturn_state.angle_to(v2)
	
	if abs(angle) > 0.0001:
		rotation2 = (rotation2 + angle) % (2 * PI)
		global_rotate(Vector3.UP, angle)
	
	snapturn_state = v2
