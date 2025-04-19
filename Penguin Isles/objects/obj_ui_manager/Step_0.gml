// obj_ui_manager Step Event
var is_ui_room = (room == rm_init || room == rm_main_menu || room == rm_map || room == rm_pause_menu || room == rm_settings_menu);
if (!is_ui_room && !global.is_pause_menu_active) {
    if (instance_exists(inventory_instance) && active_ui == noone) {
        inventory_instance.visible = true;
    }
}
if (active_ui != noone && !instance_exists(active_ui)) {
    active_ui = noone;  // Clear if destroyed
    if (instance_exists(inventory_instance)) {
        inventory_instance.visible = true;
        show_debug_message("UI Manager restored inventory visibility.");
    }
}

