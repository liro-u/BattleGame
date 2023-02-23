tool
extends ScrollContainer
class_name AutoScroll

export var h = true
export var v = false
var text = ""
onready var tween_slide = $CurveTween
export(NodePath) var text_path
export var scroll_speed = 50
export var wait_at_end = 3.0
export var wait_at_start = 1.0
var subTitle

func _ready():
	subTitle = get_node(text_path)
	if h:
		get_h_scrollbar().rect_scale.y = 0
	if v:
		get_v_scrollbar().rect_scale.x = 0
	
func initialize(t):
	text = t
	subTitle.text = text
	subTitle.rect_min_size.x = 0
	get_child(0).rect_min_size.y = subTitle.rect_size.y
	rect_min_size.y = get_child(0).rect_min_size.y
	call_deferred("slide_auto_h")

func slide_auto_h():
	if tween_slide.is_active():
		tween_slide.stop_all()
		tween_slide.remove_all()
	if get_child(0).rect_size.x > rect_size.x:
		tween_slide.play((get_child(0).rect_size.x - rect_size.x - scroll_horizontal) / scroll_speed , scroll_horizontal, get_child(0).rect_size.x - rect_size.x)


func scroll_h(sat):
	scroll_horizontal = sat


func wait_time():
	yield(get_tree().create_timer(wait_at_end), "timeout")
	scroll_horizontal = 0
	yield(get_tree().create_timer(wait_at_start), "timeout")
	slide_auto_h()
