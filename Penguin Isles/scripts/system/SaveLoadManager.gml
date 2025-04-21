/// @function SaveLoadManager_Initialize()
/// @description Initializes the save/load system
function SaveLoadManager_Initialize() {
    global.gameState.saveSystem = {
        version: "1.0.0",
        lastSaveTime: undefined,
        autoSaveEnabled: true,
        autoSaveInterval: 300, // 5 minutes in seconds
        saveFilePath: "savegame.sav"
    };
    
    LogMessage(global.LogLevel.INFO, "SaveLoadManager initialized");
}

/// @function SaveLoadManager_SaveGame()
/// @description Saves the current game state to file
/// @returns {Bool} True if save was successful
function SaveLoadManager_SaveGame() {
    try {
        var _saveData = {
            // Save metadata
            version: global.gameState.saveSystem.version,
            timestamp: date_current_datetime(),
            
            // Game state
            player: {
                x: GlobalState_Get("player.position.x"),
                y: GlobalState_Get("player.position.y"),
                skin: GlobalState_Get("player.skin"),
                color: GlobalState_Get("player.color"),
                face: GlobalState_Get("player.face")
            },
            
            // Room state
            currentRoom: room_get_name(room),
            roomStates: {},
            
            // Inventory state
            inventory: {
                slots: GlobalState_Get("inventory.slots"),
                equipped: SaveLoadManager_ConvertDsMapToStruct(
                    GlobalState_Get("inventory.equipped")
                ),
                activeSlot: GlobalState_Get("inventory.activeSlot")
            },
            
            // Quest and progress state
            gameProgress: {
                activeQuests: ds_list_to_array_recursive(global.active_quests),
                completedQuests: ds_list_to_array_recursive(global.completed_quests),
                flags: global.gameFlags ?? {}
            }
        };
        
        // Convert room states from ds_map to struct
        var _roomStates = GlobalState_Get("room.states");
        var _roomKeys = ds_map_keys_to_array(_roomStates);
        for (var i = 0; i < array_length(_roomKeys); i++) {
            var _key = _roomKeys[i];
            _saveData.roomStates[$ _key] = ds_map_find_value(_roomStates, _key);
        }
        
        // Convert save data to JSON
        var _jsonString = json_stringify(_saveData);
        if (_jsonString == "") {
            LogMessage(global.LogLevel.ERROR, "Failed to stringify save data");
            return false;
        }
        
        // Write to file
        var _file = file_text_open_write(global.gameState.saveSystem.saveFilePath);
        if (_file == -1) {
            LogMessage(global.LogLevel.ERROR, "Failed to open save file for writing");
            return false;
        }
        
        file_text_write_string(_file, _jsonString);
        file_text_close(_file);
        
        // Update last save time
        global.gameState.saveSystem.lastSaveTime = date_current_datetime();
        
        LogMessage(global.LogLevel.INFO, "Game saved successfully", {
            timestamp: _saveData.timestamp,
            room: _saveData.currentRoom
        });
        
        return true;
    } catch(_error) {
        LogMessage(global.LogLevel.ERROR, "Error saving game", _error);
        return false;
    }
}

/// @function SaveLoadManager_LoadGame()
/// @description Loads game state from file
/// @returns {Bool} True if load was successful
function SaveLoadManager_LoadGame() {
    try {
        if (!file_exists(global.gameState.saveSystem.saveFilePath)) {
            LogMessage(global.LogLevel.ERROR, "Save file does not exist");
            return false;
        }
        
        // Read save file
        var _file = file_text_open_read(global.gameState.saveSystem.saveFilePath);
        if (_file == -1) {
            LogMessage(global.LogLevel.ERROR, "Failed to open save file for reading");
            return false;
        }
        
        var _jsonString = "";
        while (!file_text_eof(_file)) {
            _jsonString += file_text_readln(_file);
        }
        file_text_close(_file);
        
        // Parse save data
        var _saveData = json_parse(_jsonString);
        if (!is_struct(_saveData)) {
            LogMessage(global.LogLevel.ERROR, "Invalid save data format");
            return false;
        }
        
        // Version check
        if (_saveData.version != global.gameState.saveSystem.version) {
            LogMessage(global.LogLevel.WARNING, "Save version mismatch", {
                save: _saveData.version,
                current: global.gameState.saveSystem.version
            });
        }
        
        // Set loading flag
        GlobalState_Set("game.is_loading", true);
        
        // Restore player state
        GlobalState_Set("player.position.x", _saveData.player.x);
        GlobalState_Set("player.position.y", _saveData.player.y);
        GlobalState_Set("player.skin", _saveData.player.skin);
        GlobalState_Set("player.color", _saveData.player.color);
        GlobalState_Set("player.face", _saveData.player.face);
        
        // Restore inventory
        GlobalState_Set("inventory.slots", _saveData.inventory.slots);
        SaveLoadManager_ConvertStructToDsMap(
            _saveData.inventory.equipped,
            GlobalState_Get("inventory.equipped")
        );
        GlobalState_Set("inventory.activeSlot", _saveData.inventory.activeSlot);
        
        // Restore room states
        var _roomStates = GlobalState_Get("room.states");
        ds_map_clear(_roomStates);
        var _roomNames = variable_struct_get_names(_saveData.roomStates);
        for (var i = 0; i < array_length(_roomNames); i++) {
            var _key = _roomNames[i];
            ds_map_add(_roomStates, _key, _saveData.roomStates[$ _key]);
        }
        
        // Set target room
        GlobalState_Set("room.target", asset_get_index(_saveData.currentRoom));
        
        // Restore quest state
        ds_list_clear(global.active_quests);
        ds_list_clear(global.completed_quests);
        array_copy_to_list(_saveData.gameProgress.activeQuests, global.active_quests);
        array_copy_to_list(_saveData.gameProgress.completedQuests, global.completed_quests);
        
        // Restore game flags
        global.gameFlags = _saveData.gameProgress.flags;
        
        LogMessage(global.LogLevel.INFO, "Game loaded successfully", {
            timestamp: _saveData.timestamp,
            room: _saveData.currentRoom
        });
        
        return true;
    } catch(_error) {
        LogMessage(global.LogLevel.ERROR, "Error loading game", _error);
        GlobalState_Set("game.is_loading", false);
        return false;
    }
}

/// @function SaveLoadManager_ConvertDsMapToStruct(map)
/// @param {Id.DsMap} map The ds_map to convert
/// @returns {Struct} A struct representation of the map
function SaveLoadManager_ConvertDsMapToStruct(_map) {
    var _struct = {};
    var _keys = ds_map_keys_to_array(_map);
    
    for (var i = 0; i < array_length(_keys); i++) {
        var _key = _keys[i];
        _struct[$ _key] = ds_map_find_value(_map, _key);
    }
    
    return _struct;
}

/// @function SaveLoadManager_ConvertStructToDsMap(struct, map)
/// @param {Struct} struct The struct to convert
/// @param {Id.DsMap} map The ds_map to populate
function SaveLoadManager_ConvertStructToDsMap(_struct, _map) {
    ds_map_clear(_map);
    var _keys = variable_struct_get_names(_struct);
    
    for (var i = 0; i < array_length(_keys); i++) {
        var _key = _keys[i];
        ds_map_add(_map, _key, _struct[$ _key]);
    }
}

/// @function SaveLoadManager_AutoSave()
/// @description Handles auto-saving if enabled
function SaveLoadManager_AutoSave() {
    if (!global.gameState.saveSystem.autoSaveEnabled) return;
    
    var _currentTime = date_current_datetime();
    var _lastSaveTime = global.gameState.saveSystem.lastSaveTime;
    
    if (_lastSaveTime == undefined || 
        date_second_span(_lastSaveTime, _currentTime) >= global.gameState.saveSystem.autoSaveInterval) {
        SaveLoadManager_SaveGame();
    }
} 