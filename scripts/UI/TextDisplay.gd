extends Control

@onready var backing = $Backing
@onready var textbox = $TextBox


func _ready():
	change_text("")

func _process(_delta):
	var mpos = get_global_mouse_position()
	position = mpos - Vector2(16,16)
	
	if mpos.x > get_viewport_rect().size.x / 2:
		position.x -= backing.size.x - 32
	#if mpos.y > get_viewport_rect().size.y /2:
		#position.y -= backing.size.y - 32

func change_text(new_text):
	textbox.fit_content = true
	backing.size = textbox.size + Vector2(16,16)
	await get_tree().process_frame
	textbox.text = new_text
