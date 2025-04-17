// obj_hud_expanded: Create Event
depth = -10000;
inventory = obj_inventory.inventory;
inventory_size = obj_inventory.inventory_size;
active_slot = obj_inventory.active_slot;
global.active_item_index = active_slot;
global.is_special_actions_open = false
is_active = true;
global.expanded_hud_instance = id;