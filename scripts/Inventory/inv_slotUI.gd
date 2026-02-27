extends Panel

@onready var item_display: TextureRect = $CenterContainer/Panel/item_display

func update(slot: InvSlot):
	if slot == null or slot.item == null:
		item_display.visible = false
	else:
		item_display.visible = true
		item_display.texture = slot.item.texture
		
