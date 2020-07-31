extends HBoxContainer
var heart = preload("res://icon.png")

func setup(max_hearts):
    set("custom_constants/separator", max_hearts)
    for i in max_hearts:
        var s = Sprite.new()
        s.texture = heart
        s.position.x *= i * 10
        add_child(s)
        
func update_hearts(value):
    for i in get_child_count():
        get_child(i).visible = value > i
