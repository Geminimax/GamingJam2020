extends Control

const anchors = [[0.0, 0.5], [0.5, 1.0], [1.0, 0.5], [0.5, 0.0], [0.5, 0.5]]
var is_open = false
var tween : Tween
var hide_timer : Timer
var show_timer : Timer
var radius = 30
func _ready():
    for child in get_children():
        child.anchor_left = 0.5
        child.anchor_right = 0.5
        child.anchor_bottom = 0.5
        child.anchor_top = 0.5
    tween = $"../Tween"
    hide_timer = $"../HideTimer"
    show_timer = $"../ShowTimer"
    
func show():
    if !is_open && show_timer:
        print("started")
        is_open = true
        show_timer.start()

func show_info():
    var time = 0.3
    var trans = Tween.TRANS_CUBIC
    var ease_mode = Tween.EASE_OUT
    visible = true
    is_open = true
    var children = get_children()
    
    for i in get_child_count():
        var angle = (360/get_child_count()) * i
        var goal_pos = Vector2.RIGHT.rotated(deg2rad(angle)) * radius
#        tween.interpolate_property(children[i],
#            "anchor_top", children[i].anchor_top, anchors[i][0], time,trans,ease_mode)
#        tween.interpolate_property(children[i],
#            "anchor_bottom", children[i].anchor_bottom, anchors[i][0], time,trans,ease_mode)
#        tween.interpolate_property(children[i],
#            "anchor_left", children[i].anchor_left, anchors[i][1], time,trans,ease_mode)
#        tween.interpolate_property(children[i],
#            "anchor_right", children[i].anchor_right, anchors[i][1], time,trans,ease_mode)
        tween.interpolate_property(children[i],
            "rect_position", children[i].rect_position, goal_pos, time,trans,ease_mode)
        tween.interpolate_property(children[i],
            "modulate:a", children[i].modulate.a, 1.0, time,trans,ease_mode)
    tween.start()
func hide():
    if(is_open):
        is_open = false
        hide_timer.start()
func hide_info():
    tween.stop_all()
    var time = 0.2
    var trans = Tween.TRANS_CUBIC
    var ease_mode = Tween.EASE_IN
    
    for child in get_children():
#        tween.interpolate_property(child,
#            "anchor_top", child.anchor_top, 0.5, time,trans,ease_mode)
#        tween.interpolate_property(child,
#            "anchor_bottom", child.anchor_bottom, 0.5, time,trans,ease_mode)
#        tween.interpolate_property(child,
#            "anchor_left", child.anchor_left, 0.5, time,trans,ease_mode)
#        tween.interpolate_property(child,
#            "anchor_right", child.anchor_right, 0.5, time,trans,ease_mode)tween.interpolate_property(child,
#            "anchor_right", child.anchor_right, 0.5, time,trans,ease_mode)
        tween.interpolate_property(child,
                    "rect_position", child.rect_position, Vector2.ZERO, time,trans,ease_mode)
        tween.interpolate_property(child,
            "modulate:a", child.modulate.a, 0.0, time,trans,ease_mode)
    tween.start()
    yield(tween,"tween_all_completed")
    if !is_open:
        visible = false

func quick_hide():
    is_open = false
    hide_info()
    
func quick_show():
    is_open = true 
    show_info()
    
func _on_HideTimer_timeout():
    if(!is_open):
        hide_info()


func _on_ShowTimer_timeout():
    if(is_open):
        show_info()
