/// @function InventoryManager_Initialize()
/// @description Initializes the inventory management system
function InventoryManager_Initialize() {
    global.gameState.inventory = {
        slots: array_create(INVENTORY_SIZE, -1),
        equipped: ds_map_create(),
        activeSlot: 0,
        isExpanded: false,
        
        // Equipment slots configuration
        equipmentSlots: {
            head: -1,
            face: -1,
            neck: -1,
            body: -1,
            hand: -1,
            feet: -1
        }
    };
    
    // Initialize equipment slots
    var _slots = variable_struct_get_names(global.gameState.inventory.equipmentSlots);
    for (var i = 0; i < array_length(_slots); i++) {
        ds_map_add(global.gameState.inventory.equipped, _slots[i], -1);
    }
    
    LogMessage(global.LogLevel.INFO, "InventoryManager initialized");
}

/// @function InventoryManager_AddItem(itemName)
/// @param {String} itemName Name of the item to add
/// @returns {Bool} True if item was added successfully
function InventoryManager_AddItem(_itemName) {
    try {
        var _inventory = global.gameState.inventory.slots;
        
        // Find first empty slot
        for (var i = 0; i < array_length(_inventory); i++) {
            if (_inventory[i] == -1) {
                _inventory[i] = _itemName;
                
                LogMessage(global.LogLevel.INFO, "Item added to inventory", {
                    item: _itemName,
                    slot: i
                });
                
                return true;
            }
        }
        
        LogMessage(global.LogLevel.WARNING, "Inventory full - couldn't add item", _itemName);
        return false;
    } catch(_error) {
        LogMessage(global.LogLevel.ERROR, "Error adding item to inventory", {
            item: _itemName,
            error: _error
        });
        return false;
    }
}

/// @function InventoryManager_EquipItem(slot, itemName)
/// @param {String} slot Equipment slot to use
/// @param {String} itemName Item to equip
/// @returns {Bool} True if item was equipped successfully
function InventoryManager_EquipItem(_slot, _itemName) {
    try {
        var _equipped = global.gameState.inventory.equipped;
        
        // Validate slot exists
        if (!ds_map_exists(_equipped, _slot)) {
            LogMessage(global.LogLevel.ERROR, "Invalid equipment slot", _slot);
            return false;
        }
        
        // Check if something is already equipped
        var _currentItem = _equipped[? _slot];
        if (_currentItem != -1) {
            // Try to move current item to inventory
            if (!InventoryManager_AddItem(_currentItem)) {
                LogMessage(global.LogLevel.WARNING, "Cannot unequip item - inventory full", _currentItem);
                return false;
            }
        }
        
        // Equip new item
        _equipped[? _slot] = _itemName;
        
        LogMessage(global.LogLevel.INFO, "Item equipped", {
            slot: _slot,
            item: _itemName
        });
        
        return true;
    } catch(_error) {
        LogMessage(global.LogLevel.ERROR, "Error equipping item", {
            slot: _slot,
            item: _itemName,
            error: _error
        });
        return false;
    }
} 