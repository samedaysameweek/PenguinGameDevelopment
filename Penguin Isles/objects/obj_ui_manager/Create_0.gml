// obj_ui_manager Create Event
persistent = true; // Make persistent to stay across rooms
global.ui_manager = id;
active_ui = noone;  // Current UI instance
inventory_instance = instance_exists(obj_inventory) ? obj_inventory : instance_create_layer(0, 0, "UI", obj_inventory);
depth = -1000;  // Above all UI elements
show_debug_message("UI Manager initialized.");