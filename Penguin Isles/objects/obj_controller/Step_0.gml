/// Step Event for obj_controller

if (instance_exists(global.player_instance)) {
    // Determine target camera position based on player instance
    var target_x = global.player_instance.x - (camera_get_view_width(global.camera) / 2);
    var target_y = global.player_instance.y - (camera_get_view_height(global.camera) / 2);

    // Clamp camera position to ensure it doesn't go out of room bounds
    target_x = clamp(target_x, 0, room_width - camera_get_view_width(global.camera));
    target_y = clamp(target_y, 0, room_height - camera_get_view_height(global.camera));

    // Smoothly transition the camera to the target position using linear interpolation
    camera_set_view_pos(
        global.camera,
        lerp(camera_get_view_x(global.camera), target_x, 0.1),
        lerp(camera_get_view_y(global.camera), target_y, 0.1)
    );
} else {
    // Log warning if no player instance exists
    show_debug_message("WARNING: Player instance not found. Camera cannot follow.");
}

global.click_handled = false;
// Toggle Pause Menu with ESC
if (keyboard_check_pressed(vk_escape) && !global.colour_picker_active) {
    global.is_pause_menu_active = !global.is_pause_menu_active;
    if (global.is_pause_menu_active) {
        global.player_controls_enabled = false;
        show_debug_message("Game Paused");
    } else {
        global.player_controls_enabled = true;
        if (instance_exists(obj_inventory)) {
            obj_inventory.visible = true;  // Restore inventory
        }
        show_debug_message("Game Resumed");
    }
}

// Toggle expanded inventory
if (keyboard_check_pressed(ord("I"))) {
    if (instance_exists(obj_inventory_expanded)) {
        with (obj_inventory_expanded) {
            instance_destroy();
        }
        global.game_paused = false;
    } else {
        instance_create_layer(0, 0, "Instances", obj_inventory_expanded);
        global.game_paused = true;
    }
}

// Toggle icetruck colour picker with "C" when skin is icetruck
if (keyboard_check_pressed(ord("C")) && global.current_skin == "icetruck") {
    if (instance_exists(obj_icetruck_colourpicker)) {
        with (obj_icetruck_colourpicker) instance_destroy();
    } else {
        instance_create_layer(0, 0, "Instances", obj_icetruck_colourpicker);
    }
}

// Ensure inventory visibility in non-UI rooms
var is_ui_room = (room == rm_init || room == rm_main_menu || room == rm_map || room == rm_pause_menu || room == rm_settings_menu);
if (!is_ui_room && instance_exists(obj_inventory)) {
    if (!global.is_pause_menu_active) {  // Only show when not paused
        obj_inventory.visible = false;
    }
}

// Hide or show the player in UI rooms
if (is_ui_room) {
    if (instance_exists(global.player_instance)) {
        global.player_instance.visible = false;
        show_debug_message("DEBUG: UI Room detected. Player instance hidden.");
    }
} else {
    if (!instance_exists(global.player_instance)) {
        show_debug_message("WARNING: No player instance found. Recreating...");
        var player_x = global.player_x;
        var player_y = global.player_y;
        var player_obj;
        switch (global.current_skin) {
            case "player":
                player_obj = obj_player;
                break;
            case "toboggan":
                player_obj = obj_player_toboggan;
                break;
            case "tube":
                player_obj = obj_player_tube;
                break;
            case "icetruck":
                player_obj = obj_player_icetruck;
                break;
            case "sled_player":
                player_obj = obj_sled_player;
                break;
            case "ninja":
                player_obj = obj_player_ninja;
                break;
            default:
                player_obj = obj_player;
        }
        global.player_instance = instance_create_layer(player_x, player_y, "Instances", player_obj);
        show_debug_message("DEBUG: Player recreated in Step event at (" + string(player_x) + ", " + string(player_y) + ") with skin: " + global.current_skin);
    } else {
        global.player_instance.visible = true;
    }
}

if (room == rm_sled_racing) {
    switch_skin("sled_player");
}

// Function to start a quest
function start_quest(quest_id) {
    if (!ds_list_find_index(global.active_quests, quest_id)) {
        ds_list_add(global.active_quests, quest_id);
        var quest = ds_map_find_value(global.quest_definitions, quest_id);
        var progress = ds_map_create();
        for (var i = 0; i < array_length(quest[?"objectives"]); i++) {
            ds_map_add(progress, i, false); // Not completed
        }
        ds_map_add(global.quest_progress, quest_id, progress);
        show_debug_message("Started quest: " + quest[?"name"]);
    }
}

// Function to check quest completion
function check_quest_completion(quest_id) {
    var progress = ds_map_find_value(global.quest_progress, quest_id);
    if (progress == undefined) return false;
    var quest = ds_map_find_value(global.quest_definitions, quest_id);
    var objectives = quest[?"objectives"];
    for (var i = 0; i < array_length(objectives); i++) {
        var obj = objectives[i];
        if (obj.type == "collect") {
            var item_count = obj_inventory.get_inventory_item_count(obj.item);
            if (item_count < obj.amount) return false;
        } else if (obj.type == "talk") {
            if (!ds_map_find_value(progress, i)) return false;
        }
    }
    return true;
}

// Function to complete a quest
function complete_quest(quest_id) {
    var index = ds_list_find_index(global.active_quests, quest_id);
    if (index != -1) {
        ds_list_delete(global.active_quests, index);
        ds_list_add(global.completed_quests, quest_id);
        var quest = ds_map_find_value(global.quest_definitions, quest_id);
        var rewards = quest[?"rewards"];
        if (variable_struct_exists(rewards, "coins")) {
            global.coins = variable_global_exists("coins") ? global.coins + rewards.coins : rewards.coins;
        }
        if (variable_struct_exists(rewards, "item")) {
            obj_inventory.add_to_inventory(rewards.item);
        }
        var progress = ds_map_find_value(global.quest_progress, quest_id);
        ds_map_destroy(progress);
        ds_map_delete(global.quest_progress, quest_id);
        show_debug_message("Completed quest: " + quest[?"name"]);
    }
}
