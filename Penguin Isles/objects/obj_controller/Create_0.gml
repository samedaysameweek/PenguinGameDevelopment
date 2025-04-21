// --- INITIALIZE NEW SYSTEMS ---
// Only initialize if the functions exist and haven't been initialized yet
if (!variable_global_exists("systems_initialized") || global.systems_initialized == false) {
    var has_error_logger = script_exists(asset_get_index("ErrorLogger_Initialize"));
    var has_room_state_manager = script_exists(asset_get_index("RoomStateManager_Initialize"));
    
    if (has_error_logger) {
        show_debug_message("obj_controller: Initializing new system - ErrorLogger");
        ErrorLogger_Initialize();
    }
    
    if (has_room_state_manager) {
        show_debug_message("obj_controller: Initializing new system - RoomStateManager");
        RoomStateManager_Initialize();
    }
    
    if (script_exists(asset_get_index("GlobalStateManager_Initialize"))) {
        show_debug_message("obj_controller: Initializing new system - GlobalStateManager");
        GlobalStateManager_Initialize();
    }
    
    if (script_exists(asset_get_index("InventoryManager_Initialize"))) {
        show_debug_message("obj_controller: Initializing new system - InventoryManager");
        InventoryManager_Initialize();
    }
    
    global.systems_initialized = true;
} else {
    show_debug_message("obj_controller: New systems already initialized, skipping initialization.");
}
// --- END INITIALIZE NEW SYSTEMS --- 

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

// *** ADD INITIALIZATION FOR chat_active ***
if (!variable_global_exists("chat_active")) {
    global.chat_active = false;
    show_debug_message("Initialized global.chat_active in obj_controller Create.");
}
// *** END ADDED INITIALIZATION ***

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

/// @method switch_skin(new_skin_name)
/// @description Destroys current player instance and creates a new one based on skin name.
/// @param {string} new_skin_name The name of the skin to switch to (e.g., "player", "icetruck").
/// @returns {bool} True if switch was successful, false otherwise.
switch_skin = function(new_skin_name) {
    // ... (function definition remains the same) ...
} // End of switch_skin method definition

// ... (rest of Create event, including global.skins, global.player_colors, etc.) ... 