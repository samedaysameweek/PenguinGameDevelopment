/// @function init_globals()
/// @description Initializes global variables and ensures essential DYNAMIC structures exist.
///              Only sets default *game state* values for a new game.
///              Static item data is handled separately by scr_initialize_item_data().
function init_globals() {
    show_debug_message("--- Running init_globals (Refactored) ---");

    // --- Section 1: Ensure Essential Flags/Variables Exist (Run Always) ---
    if (!variable_global_exists("is_loading_game")) { global.is_loading_game = false; }
    if (!variable_global_exists("player_instance")) { global.player_instance = noone; }
    if (!variable_global_exists("inventory_expanded")) { global.inventory_expanded = false; show_debug_message("Ensured global.inventory_expanded exists."); }
    if (!variable_global_exists("game_paused")) { global.game_paused = false; show_debug_message("Ensured global.game_paused exists."); }
    if (!variable_global_exists("is_pause_menu_active")) { global.is_pause_menu_active = false; show_debug_message("Ensured global.is_pause_menu_active exists."); }
    if (!variable_global_exists("player_controls_enabled")) { global.player_controls_enabled = true; show_debug_message("Ensured global.player_controls_enabled exists."); }
    if (!variable_global_exists("colour_picker_active")) { global.colour_picker_active = false; show_debug_message("Ensured global.colour_picker_active exists."); }
    // Keep party_hat_visible/beta_hat_visible for now, but they might be redundant if relying purely on equipped_items
    if (!variable_global_exists("party_hat_visible")) { global.party_hat_visible = false; show_debug_message("Ensured global.party_hat_visible exists."); }
    if (!variable_global_exists("beta_hat_visible")) { global.beta_hat_visible = false; show_debug_message("Ensured global.beta_hat_visible exists."); }
    if (!variable_global_exists("skin_switching")) { global.skin_switching = false; show_debug_message("Ensured global.skin_switching exists."); }

    // --- Section 2: Ensure Core DYNAMIC Data Structures Exist (Run Always) ---
    //                 (Don't clear here if loading, only ensure existence)
    //                 Item lookup maps (item_index_map etc.) are handled by scr_initialize_item_data
    if (!variable_global_exists("following_puffles") || !ds_exists(global.following_puffles, ds_type_list)) { if (variable_global_exists("following_puffles") && ds_exists(global.following_puffles, ds_type_list)) ds_list_destroy(global.following_puffles); global.following_puffles = ds_list_create(); show_debug_message("Ensured global.following_puffles list exists."); }
    if (!variable_global_exists("room_states") || !ds_exists(global.room_states, ds_type_map)) { if (variable_global_exists("room_states") && ds_exists(global.room_states, ds_type_map)) ds_map_destroy(global.room_states); global.room_states = ds_map_create(); show_debug_message("Ensured global.room_states map exists."); }
    if (!variable_global_exists("active_quests") || !ds_exists(global.active_quests, ds_type_list)) { if (variable_global_exists("active_quests") && ds_exists(global.active_quests, ds_type_list)) ds_list_destroy(global.active_quests); global.active_quests = ds_list_create(); show_debug_message("Ensured global.active_quests list exists."); }
    if (!variable_global_exists("completed_quests") || !ds_exists(global.completed_quests, ds_type_list)) { if (variable_global_exists("completed_quests") && ds_exists(global.completed_quests, ds_type_list)) ds_list_destroy(global.completed_quests); global.completed_quests = ds_list_create(); show_debug_message("Ensured global.completed_quests list exists."); }
    // Inventory array (ensure it exists, size might be set here or defaults later)
    if (!variable_global_exists("inventory") || !is_array(global.inventory)) {
	    global.inventory = array_create(INVENTORY_SIZE, -1); // Use macro
	    show_debug_message("Ensured global.inventory array exists (Size " + string(INVENTORY_SIZE) + ").");
	}
    // Equipped items map (ensure it exists with base slots)
    if (!variable_global_exists("equipped_items") || !ds_exists(global.equipped_items, ds_type_map)) { if (variable_global_exists("equipped_items") && ds_exists(global.equipped_items, ds_type_map)) ds_map_destroy(global.equipped_items); global.equipped_items = ds_map_create(); ds_map_add(global.equipped_items, "head", -1); ds_map_add(global.equipped_items, "face", -1); ds_map_add(global.equipped_items, "neck", -1); ds_map_add(global.equipped_items, "body", -1); ds_map_add(global.equipped_items, "hand", -1); ds_map_add(global.equipped_items, "feet", -1); show_debug_message("Ensured global.equipped_items map exists with slots."); }

    // --- Camera Initialization (Run Always) ---
    if (!variable_global_exists("camera") || !is_real(global.camera) || global.camera < 0) {
        if (variable_global_exists("camera")) { show_debug_message("init_globals: global.camera holds invalid value (" + string(global.camera) + "). Recreating camera."); }
        else { show_debug_message("init_globals: global.camera variable does not exist. Creating camera."); }
        global.camera = camera_create();
        view_set_camera(0, global.camera);
        show_debug_message("init_globals: Created new global.camera. ID: " + string(global.camera));
    } else {
        show_debug_message("init_globals: Valid global.camera already exists. ID: " + string(global.camera));
        if (view_get_camera(0) != global.camera) {
            view_set_camera(0, global.camera);
            show_debug_message("init_globals: Ensured view 0 uses existing global.camera.");
        }
    }

    // --- Section 3: Loading Check ---
    if (variable_global_exists("is_loading_game") && global.is_loading_game == true) {
        show_debug_message("init_globals: Skipping NEW GAME default value assignments during game load.");
        exit; // Don't set new game defaults if loading
    }

    // --- Section 4: Default Value Assignments (Only for NEW GAME) ---
    show_debug_message("init_globals: Setting default values for NEW GAME.");
    global.player_x = 170;
    global.player_y = 154;
    global.warp_target_x = undefined;
    global.warp_target_y = undefined;
    global.warp_target_face = undefined;
    global.player_health = 100;
    global.score = 0;
    global.repair_complete = false; // Used by obj_inventory check
    global.player_color = make_color_rgb(7, 167, 163); // Default starting color (Cyan)
	global.inventory = array_create(INVENTORY_SIZE, -1); // Use macro

    // Clear DYNAMIC data structures specifically for a NEW game
    if (ds_exists(global.following_puffles, ds_type_list)) { ds_list_clear(global.following_puffles); }
    // Clear room_states map and destroy any contained lists
    if (ds_exists(global.room_states, ds_type_map)) {
         var _keys = ds_map_keys_to_array(global.room_states);
         for (var i = 0; i < array_length(_keys); i++) {
             var _list = global.room_states[? _keys[i]];
             if (ds_exists(_list, ds_type_list)) { ds_list_destroy(_list); }
         }
         ds_map_clear(global.room_states);
     }
    if (ds_exists(global.active_quests, ds_type_list)) { ds_list_clear(global.active_quests); }
    if (ds_exists(global.completed_quests, ds_type_list)) { ds_list_clear(global.completed_quests); }
    // Reset inventory array
    global.inventory = array_create(42, -1);
    // Reset equipped items map
    if (ds_exists(global.equipped_items, ds_type_map)) {
        ds_map_clear(global.equipped_items);
        ds_map_add(global.equipped_items, "head", -1); ds_map_add(global.equipped_items, "face", -1); ds_map_add(global.equipped_items, "neck", -1); ds_map_add(global.equipped_items, "body", -1); ds_map_add(global.equipped_items, "hand", -1); ds_map_add(global.equipped_items, "feet", -1);
    }

    show_debug_message("Finished setting default values via init_globals.");
}