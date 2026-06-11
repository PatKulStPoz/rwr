extends XRController3D

@onready var ray: RayCast3D = $TeleportRay
@onready var marker: MeshInstance3D = $TeleportMarker
var xr_origin: XROrigin3D
var xr_camera: XRCamera3D
var lastTeleport = 0

func _ready() -> void:
	xr_origin = get_parent() as XROrigin3D
	xr_camera = xr_origin.get_node("XRCamera3D") as XRCamera3D
	marker.visible = false
	self.button_pressed.connect(press_button)

func _process(_delta: float) -> void:
	if ray.is_colliding():
		marker.global_transform.origin = ray.get_collision_point()
		marker.visible = true
		# if Input.is_action_just_pressed("teleport"):
		#	if lastTeleport + 1000 * 5 < Time.get_ticks_msec():
		#		lastTeleport = Time.get_ticks_msec()
		#		teleport_now()
		#else:
		#	lastTeleport = 0
			
		
	else:
		marker.visible = false

func press_button(name: String) -> void:
	if (name == "trigger_click"):
		teleport_now()

func teleport_now() -> void:
	if not ray.is_colliding():
		return
	var target: Vector3 = ray.get_collision_point()
	
				
	var origin_tf := xr_origin.global_transform
	var cam_tf := xr_camera.global_transform
	var cam_offset := cam_tf.origin - origin_tf.origin
	
	target.y += 1

	origin_tf.origin = target - cam_offset
	xr_origin.global_transform = origin_tf
