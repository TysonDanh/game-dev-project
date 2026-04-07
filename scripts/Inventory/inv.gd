extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

#Handles the pick up the the item
func insert(item: InvItem):
	var emptyslots = slots.filter(func(slot): return slot.item == null)
	if !emptyslots.is_empty():
		var new_slot = emptyslots[0].duplicate()
		new_slot.item = item
		new_slot.amount = 1
		
		var index = slots.find(emptyslots[0])
		slots[index] = new_slot
		update.emit()
		return true
#Handles the drop item
func drop() -> InvItem:
	for i in range(slots.size()):
		var slot = slots[i]
		if slot.item != null and slot.amount > 0:
			var removeitem = slot.item
			var new_slot = slot.duplicate()
			new_slot.item = null
			new_slot.amount = 0
			slots[i] = new_slot
			update.emit()
			return removeitem
	return null

#Checks if item is in inv, for Building
func has_item(item: InvItem) -> bool:
	for slot in slots:
		if slot.item == item:
			return true
	return false
	
#Removes the items to be used for building
func remove_item(item: InvItem) -> bool:
	for i in range(slots.size()):
		var slot = slots[i]

		if slot.item == item and slot.amount > 0:
			var new_slot = slot.duplicate()
			new_slot.amount -= 1

			if new_slot.amount <= 0:
				new_slot.item = null

			slots[i] = new_slot
			update.emit()
			return true

	return false
	
