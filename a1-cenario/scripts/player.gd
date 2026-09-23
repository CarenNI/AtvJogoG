extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -300.0

# Pega a gravidade definida nas configurações do projeto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	# Aplica a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento horizontal (setas / A e D)
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Troca de animação conforme o estado
	if is_on_floor():
		if direction > 0:
			sprite.flip_h = false
			sprite.play("walk")
		elif direction < 0:
			sprite.flip_h = true
			sprite.play("walk")
		else:
			sprite.play("idle")
	else:
		sprite.play("jump")

# Mensagem aparece quando o pinguim pisa na área do chão
func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == self:
		$"../Area2D/Label".visible = true

# Mensagem some quando o pinguim sai da área
func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == self:
		$"../Area2D/Label".visible = false
