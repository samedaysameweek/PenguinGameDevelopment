/// Create Event for obj_controller

// --- ONE-TIME STATIC DATA INITIALIZATION ---
// Check if static data has already been initialized
if (!variable_global_exists("static_data_initialized") || global.static_data_initialized == false) {
    scr_initialize_item_data(); // Call the new script
    global.static_data_initialized = true; // Set flag to prevent re-running
    show_debug_message("obj_controller Create: Executed scr_initialize_item_data.");
} else {
    show_debug_message("obj_controller Create: Static item data already initialized, skipping scr_initialize_item_data.");
}
// --- END ONE-TIME STATIC DATA INITIALIZATION ---

/// @method switch_skin(new_skin_name)
/// @description Destroys current player instance and creates a new one based on skin name.
/// @param {string} new_skin_name The name of the skin to switch to (e.g., "player", "icetruck").
/// @returns {bool} True if switch was successful, false otherwise.
switch_skin = function(new_skin_name) {
    if (global.skin_switching) {
         show_debug_message("Skin Switch Denied: Switch already in progress.");
         return false; // Prevent overlapping switches
    }
    global.skin_switching = true;
    show_debug_message("Attempting to switch to skin: " + new_skin_name);

    // Store current player state safely
    var _x = (instance_exists(global.player_instance)) ? global.player_instance.x : global.player_x;
    var _y = (instance_exists(global.player_instance)) ? global.player_instance.y : global.player_y;
    var _face = DOWN; // Default facing
    if (instance_exists(global.player_instance) && variable_instance_exists(global.player_instance, "face")) {
        _face = global.player_instance.face;
    }

    // Store skin-specific state (Example: icetruck tint)
    var _icetruck_tint = c_yellow; // Default
    if (global.current_skin == "icetruck" && instance_exists(global.player_instance) && variable_instance_exists(global.player_instance, "icetruck_tint")) {
         _icetruck_tint = global.player_instance.icetruck_tint;
    }

    // Destroy old instance if it exists
    if (instance_exists(global.player_instance)) {
        show_debug_message("Destroying old player instance (" + string(global.player_instance) + ", skin: " + global.current_skin + ")");
        instance_destroy(global.player_instance);
        global.player_instance = noone; // Explicitly clear reference
    } else {
        show_debug_message("Warning: No existing player instance found to destroy during skin switch.");
    }


    // Find the object corresponding to the new skin name
    var new_player_obj = noone;
    var skin_found = false;
    if (variable_global_exists("skins") && is_array(global.skins)) {
         for (var i = 0; i < array_length(global.skins); i++) {
             if (global.skins[i].name == new_skin_name) {
                 if (object_exists(global.skins[i].object)) {
                    new_player_obj = global.skins[i].object;
                    skin_found = true;
                 } else {
                     show_debug_message("ERROR: Skin object for '" + new_skin_name + "' does not exist!");
                 }
                 break;
             }
         }
    } else {
         show_debug_message("ERROR: global.skins array not found or not an array!");
    }

    if (!skin_found) {
        show_debug_message("ERROR: Skin name '" + new_skin_name + "' not found in global.skins definition. Defaulting to 'player'.");
        new_skin_name = "player"; // Attempt to fallback
        new_player_obj = obj_player; // Assuming obj_player is default
        if (!object_exists(new_player_obj)) {
             show_debug_message("FATAL ERROR: Default skin obj_player doesn't exist!");
             global.skin_switching = false;
             return false; // Cannot continue
        }
    }

    // Create the new player instance
    global.player_instance = instance_create_layer(_x, _y, "Instances", new_player_obj);
    if (!instance_exists(global.player_instance)) {
          show_debug_message("FATAL ERROR: Failed to create new player instance for skin: " + new_skin_name);
          global.skin_switching = false;
          global.current_skin = "unknown"; // Reflect failed state
          return false; // Cannot continue
    }

    // Update global state and apply common properties
    global.current_skin = new_skin_name;
    global.player_instance.persistent = true; // Make sure new instance persists

    // Apply common state
    if (variable_instance_exists(global.player_instance, "face")) {
        global.player_instance.face = _face;
    }
    global.player_instance.image_blend = global.player_color;

     // Apply skin-specific state (Example: icetruck tint)
    if (new_skin_name == "icetruck" && variable_instance_exists(global.player_instance, "icetruck_tint")) {
        global.player_instance.icetruck_tint = _icetruck_tint; // Apply saved/default tint
        show_debug_message("Applied icetruck tint: " + string(_icetruck_tint));
    }

    // Update camera target
    camera_set_view_target(global.camera, global.player_instance);

    show_debug_message("Skin switched to: " + global.current_skin + ". New instance ID: " + string(global.player_instance));
    global.skin_switching = false; // Allow next switch
    return true; // Switch successful
} // End of switch_skin method definition

// --- Rest of obj_controller Create Event ---
init_globals(); // This now only ensures vars/DS and sets new game defaults

if (!variable_global_exists("colour_picker_active")) {
    global.colour_picker_active = false;
    show_debug_message("Initialized global.colour_picker_active in obj_controller Create.");
}

if (!variable_global_exists("is_game_paused")) {
         global.is_game_paused = false;
         show_debug_message("Initialized global.is_game_paused in obj_controller Create.");
    }
global.chat_active = false;
global.chat_npc = noone;
global.player_controls_enabled = true;

persistent = true; // Ensure persistence across rooms

// Initialize global variables early to avoid undefined references
global.dialogue_active = false; // Dialogue system starts inactive

// Track clicks processed by any UI elements
global.click_handled = false;
global.is_expanded = false;

// Get the FPS value for the room
var room_fps = game_get_speed(gamespeed_fps);

// Initialize countdown_timer with the desired duration in seconds multiplied by room_fps
global.countdown_timer = 1 * room_fps; // 1 second countdown 
global.is_pause_menu_active = false;
global.game_started = false; // Flag to check if the game has started
global.lives = 3; // Initialize player lives
game_timer = 0; // Initialize game timer
global.skin_switching = false; // Initialize the skin switching flag

// Initialize global variables
global.skins = [
    { name: "player", object: obj_player },
    { name: "icetruck", object: obj_player_icetruck },
    { name: "tube", object: obj_player_tube },
    { name: "toboggan", object: obj_player_toboggan },
    { name: "sled_player", object: obj_sled_player },
    { name: "ninja", object: obj_player_ninja }
];

global.current_skin = "player"; // Starting skin
global.player_instance = noone; // Initialize player instance
global.icetruck_destroyed = false; // Initialize icetruck_destroyed

// Define player colors globally
global.player_colors = [
    make_color_rgb(51, 51, 51),    // notblack
    make_color_rgb(46, 71, 170),   // bluer
    make_color_rgb(153, 102, 0),   // brown
    make_color_rgb(7, 167, 163),   // cyan
    make_color_rgb(7, 106, 68),    // emerald
    make_color_rgb(6, 155, 77),    // greener
    make_color_rgb(176, 126, 194), // lavender
    make_color_rgb(8, 153, 211),   // lightblue
    make_color_rgb(189, 252, 201), // mint
    make_color_rgb(255, 102, 0),   // oranger
    make_color_rgb(255, 51, 153),  // pink
    make_color_rgb(102, 49, 158),  // purpler
    make_color_rgb(204, 0, 0),     // reder
    make_color_rgb(255, 67, 63),   // salmon
    make_color_rgb(255, 204, 0)    // yellower
];

// Room state management
if (!variable_global_exists("room_states")) {
    global.room_states = ds_map_create();
}
global.current_room = room; // Track current room

// Ensure player instance exists
if (global.player_instance == noone) {
    if (global.current_skin == "player") {
        global.player_instance = instance_create_layer(x, y, "Instances", obj_player);
    } else if (global.current_skin == "icetruck") {
        global.player_instance = instance_create_layer(x, y, "Instances", obj_player_icetruck);
    } else if (global.current_skin == "tube") {
        global.player_instance = instance_create_layer(x, y, "Instances", obj_player_tube);
    } else if (global.current_skin == "sled_player") {
        global.player_instance = instance_create_layer(x, y, "Instances", obj_sled_player);
    } else if (global.current_skin == "ninja") {
        global.player_instance = instance_create_layer(x, y, "Instances", obj_player_ninja);
    } else if (global.current_skin == "toboggan") {
        global.player_instance = instance_create_layer(x, y, "Instances", obj_player_toboggan);
    }
}

if (instance_exists(global.player_instance)) {
    global.player_instance.image_blend = global.player_color;
    show_debug_message("Restored player color: " + string(global.player_color));
} 

if (!variable_global_exists("following_puffles")) {
    global.following_puffles = ds_list_create();
}

// Quest management
global.active_quests = ds_list_create();
global.completed_quests = ds_list_create();
global.quest_progress = ds_map_create();
global.quest_definitions = ds_map_create();

// Define a sample quest
function create_quest(_id, _name, _description, _objectives, _rewards) {
    var quest = ds_map_create();
    ds_map_add(quest, "id", _id);
    ds_map_add(quest, "name", _name);
    ds_map_add(quest, "description", _description);
    ds_map_add(quest, "objectives", _objectives);
    ds_map_add(quest, "rewards", _rewards);
    return quest;
}

// Sample quest: Find the Missing Puffle
var quest1 = create_quest(
    1,
    "Find the Missing Puffle",
    "Help the NPC find their lost puffle.",
    [
        { "type": "collect", "item": "Puffle O", "amount": 1 },
        { "type": "talk", "npc": "NPC1" }
    ],
    { "coins": 100, "item": "Beta Hat" }
);
ds_map_add(global.quest_definitions, 1, quest1);

// Debugging
if (instance_exists(global.player_instance)) {
    show_debug_message("Player instance created: " + string(global.player_instance));
} else {
    show_debug_message("Error: Failed to create player instance.");
}

// Add debug message to confirm Create event runs
show_debug_message("obj_controller created with ID: " + string(id));
show_debug_message("obj_controller Create event executed");

//alarm[1] = room_speed * 5;