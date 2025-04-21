/// @function GlobalStateManager_Initialize()
/// @description Initializes the global state manager with default values
function GlobalStateManager_Initialize() {
    global.gameState = {
        // Player state
        player: {
            instance: noone,
            position: { x: 0, y: 0 },
            skin: "player",
            color: c_white,
            face: DOWN,
            controls_enabled: true
        },
        
        // Game state
        game: {
            is_paused: false,
            is_loading: false,
            inventory_expanded: false,
            repair_complete: false
        },
        
        // UI state
        ui: {
            pause_menu_active: false,
            colour_picker_active: false,
            inventory_visible: false
        },
        
        // Room state
        room: {
            current: noone,
            target: noone,
            states: ds_map_create()
        }
    };
    
    LogMessage(global.LogLevel.INFO, "GlobalStateManager initialized");
}

/// @function GlobalState_Get(path)
/// @param {String} path Dot-notation path to the desired value
/// @returns {Any} The value at the specified path, or undefined if not found
function GlobalState_Get(_path) {
    try {
        var _parts = string_split(_path, ".");
        var _current = global.gameState;
        
        for (var i = 0; i < array_length(_parts); i++) {
            if (!variable_struct_exists(_current, _parts[i])) {
                LogMessage(global.LogLevel.WARNING, "Path not found in global state", _path);
                return undefined;
            }
            _current = variable_struct_get(_current, _parts[i]);
        }
        
        return _current;
    } catch(_error) {
        LogMessage(global.LogLevel.ERROR, "Error accessing global state", {
            path: _path,
            error: _error
        });
        return undefined;
    }
}

/// @function GlobalState_Set(path, value)
/// @param {String} path Dot-notation path to set
/// @param {Any} value Value to set at the path
function GlobalState_Set(_path, _value) {
    try {
        var _parts = string_split(_path, ".");
        var _current = global.gameState;
        
        // Navigate to the parent of our target
        for (var i = 0; i < array_length(_parts) - 1; i++) {
            if (!variable_struct_exists(_current, _parts[i])) {
                _current[$ _parts[i]] = {};
            }
            _current = variable_struct_get(_current, _parts[i]);
        }
        
        // Set the value
        _current[$ _parts[array_length(_parts) - 1]] = _value;
        
        LogMessage(global.LogLevel.DEBUG, "Global state updated", {
            path: _path,
            value: _value
        });
        
        return true;
    } catch(_error) {
        LogMessage(global.LogLevel.ERROR, "Error setting global state", {
            path: _path,
            value: _value,
            error: _error
        });
        return false;
    }
} 