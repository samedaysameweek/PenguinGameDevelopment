/// @function UIStateManager_Initialize()
/// @description Initializes the UI state management system
function UIStateManager_Initialize() {
    global.gameState.ui = {
        // Menu states
        menus: {
            pause: false,
            inventory: false,
            colorPicker: false,
            shop: false,
            dialog: false
        },
        
        // Active UI elements
        activeElements: ds_list_create(),
        
        // UI settings
        settings: {
            scale: 2.2,
            showHUD: true,
            showDebug: false
        },
        
        // Dialog system state
        dialog: {
            active: false,
            text: "",
            speaker: "",
            options: [],
            callback: undefined
        }
    };
    
    LogMessage(global.LogLevel.INFO, "UIStateManager initialized");
}

/// @function UIStateManager_ShowMenu(menuName)
/// @param {String} menuName Name of the menu to show
/// @returns {Bool} True if menu was shown successfully
function UIStateManager_ShowMenu(_menuName) {
    try {
        if (!variable_struct_exists(global.gameState.ui.menus, _menuName)) {
            LogMessage(global.LogLevel.ERROR, "Invalid menu name", _menuName);
            return false;
        }
        
        // Close other menus first
        UIStateManager_CloseAllMenus();
        
        // Show requested menu
        global.gameState.ui.menus[$ _menuName] = true;
        
        // Update game state
        GlobalState_Set("game.is_paused", true);
        
        LogMessage(global.LogLevel.INFO, "Menu shown", _menuName);
        return true;
    } catch(_error) {
        LogMessage(global.LogLevel.ERROR, "Error showing menu", {
            menu: _menuName,
            error: _error
        });
        return false;
    }
}

/// @function UIStateManager_CloseAllMenus()
function UIStateManager_CloseAllMenus() {
    var _menus = variable_struct_get_names(global.gameState.ui.menus);
    for (var i = 0; i < array_length(_menus); i++) {
        global.gameState.ui.menus[$ _menus[i]] = false;
    }
    
    // Resume game
    GlobalState_Set("game.is_paused", false);
    
    LogMessage(global.LogLevel.INFO, "All menus closed");
}

/// @function UIStateManager_ShowDialog(text, [speaker], [options], [callback])
/// @param {String} text Dialog text to display
/// @param {String} [speaker] Optional speaker name
/// @param {Array} [options] Optional dialog options
/// @param {Function} [callback] Optional callback when dialog completes
function UIStateManager_ShowDialog(_text, _speaker = "", _options = [], _callback = undefined) {
    try {
        global.gameState.ui.dialog = {
            active: true,
            text: _text,
            speaker: _speaker,
            options: _options,
            callback: _callback
        };
        
        // Add dialog to active UI elements
        ds_list_add(global.gameState.ui.activeElements, "dialog");
        
        LogMessage(global.LogLevel.INFO, "Dialog shown", {
            speaker: _speaker,
            text: _text
        });
        
        return true;
    } catch(_error) {
        LogMessage(global.LogLevel.ERROR, "Error showing dialog", {
            text: _text,
            error: _error
        });
        return false;
    }
} 