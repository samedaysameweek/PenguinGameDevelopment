/// @function SystemInitializer_Initialize()
/// @description Initializes all game systems in the correct order
function SystemInitializer_Initialize() {
    // Initialize core systems first
    ErrorLogger_Initialize();
    GlobalStateManager_Initialize();
    
    // Initialize gameplay systems
    RoomStateManager_Initialize();
    InventoryManager_Initialize();
    
    // Initialize UI systems last
    UIStateManager_Initialize();
    
    LogMessage(global.LogLevel.INFO, "All systems initialized");
}

/// @function SystemInitializer_Cleanup()
/// @description Cleans up all systems properly
function SystemInitializer_Cleanup() {
    // Clean up UI systems first
    var _activeElements = global.gameState.ui.activeElements;
    if (ds_exists(_activeElements, ds_type_list)) {
        ds_list_destroy(_activeElements);
    }
    
    // Clean up gameplay systems
    var _roomStates = global.gameState.room.states;
    if (ds_exists(_roomStates, ds_type_map)) {
        ds_map_destroy(_roomStates);
    }
    
    var _equipped = global.gameState.inventory.equipped;
    if (ds_exists(_equipped, ds_type_map)) {
        ds_map_destroy(_equipped);
    }
    
    LogMessage(global.LogLevel.INFO, "All systems cleaned up");
} 