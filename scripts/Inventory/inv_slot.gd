extends Panel

@onready var item_display: Sprite2D = $item_display

func update(item: InvItem):
	if !item:
		item_display.visible = false
	else:
		item_display.visible = true
		item_display.texture = item.texture
		
