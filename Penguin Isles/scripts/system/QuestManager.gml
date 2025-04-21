/// @function QuestManager_Initialize()
/// @description Initializes the quest management system
function QuestManager_Initialize() {
    global.gameState.quests = {
        active: ds_list_create(),
        completed: ds_list_create(),
        available: ds_list_create(),
        
        // Quest definitions
        definitions: {},
        
        // Quest progress tracking
        progress: {},
        
        // Quest flags
        flags: {},
        
        // Current tracked quest
        tracked: undefined
    };
    
    // Initialize quest definitions
    QuestManager_InitializeQuests();
    
    LogMessage(global.LogLevel.INFO, "QuestManager initialized");
}

/// @function QuestManager_InitializeQuests()
/// @description Defines all available quests
function QuestManager_InitializeQuests() {
    var _quests = global.gameState.quests.definitions;
    
    // Tour Guide Mystery Quest Line
    _quests.FIND_TOUR_GUIDE = {
        id: "FIND_TOUR_GUIDE",
        title: "The Missing Tour Guide",
        description: "The island's Tour Guide has mysteriously disappeared. Find clues about their whereabouts.",
        type: "main",
        stages: [
            {
                id: "TALK_TO_WITNESSES",
                description: "Talk to penguins around the Town Center",
                required: 3,
                progress: 0
            },
            {
                id: "FIND_GUIDE_HAT",
                description: "Look for the Tour Guide's hat",
                required: 1,
                progress: 0
            },
            {
                id: "REPORT_TO_MANAGER",
                description: "Report your findings to the Manager",
                required: 1,
                progress: 0
            }
        ],
        rewards: {
            coins: 100,
            items: ["Tour Hat"],
            unlocks: ["INVESTIGATE_BOTS"]
        },
        prerequisites: []
    };
    
    _quests.INVESTIGATE_BOTS = {
        id: "INVESTIGATE_BOTS",
        title: "Suspicious Bots",
        description: "Strange bots have been spreading misinformation. Investigate their behavior.",
        type: "main",
        stages: [
            {
                id: "OBSERVE_BOTS",
                description: "Observe bot behavior in different locations",
                required: 4,
                progress: 0
            },
            {
                id: "COLLECT_EVIDENCE",
                description: "Collect evidence of bot tampering",
                required: 3,
                progress: 0
            }
        ],
        rewards: {
            coins: 150,
            items: ["EPF Phone"],
            unlocks: ["TRACK_BOT_SIGNAL"]
        },
        prerequisites: ["FIND_TOUR_GUIDE"]
    };
    
    // Add to available quests if prerequisites met
    QuestManager_UpdateAvailableQuests();
}

/// @function QuestManager_UpdateAvailableQuests()
/// @description Updates the list of available quests based on prerequisites
function QuestManager_UpdateAvailableQuests() {
    var _quests = global.gameState.quests;
    var _definitions = _quests.definitions;
    ds_list_clear(_quests.available);
    
    var _quest_ids = variable_struct_get_names(_definitions);
    for (var i = 0; i < array_length(_quest_ids); i++) {
        var _quest = _definitions[$ _quest_ids[i]];
        
        // Skip if already active or completed
        if (ds_list_find_index(_quests.active, _quest.id) != -1) continue;
        if (ds_list_find_index(_quests.completed, _quest.id) != -1) continue;
        
        // Check prerequisites
        var _prerequisites_met = true;
        for (var j = 0; j < array_length(_quest.prerequisites); j++) {
            if (ds_list_find_index(_quests.completed, _quest.prerequisites[j]) == -1) {
                _prerequisites_met = false;
                break;
            }
        }
        
        if (_prerequisites_met) {
            ds_list_add(_quests.available, _quest.id);
        }
    }
}

/// @function QuestManager_StartQuest(quest_id)
/// @param {String} quest_id ID of the quest to start
/// @returns {Bool} True if quest started successfully
function QuestManager_StartQuest(_quest_id) {
    var _quests = global.gameState.quests;
    
    // Validate quest exists
    if (!variable_struct_exists(_quests.definitions, _quest_id)) {
        LogMessage(global.LogLevel.ERROR, "Invalid quest ID", _quest_id);
        return false;
    }
    
    // Check if quest is available
    if (ds_list_find_index(_quests.available, _quest_id) == -1) {
        LogMessage(global.LogLevel.WARNING, "Quest not available", _quest_id);
        return false;
    }
    
    // Initialize quest progress
    _quests.progress[$ _quest_id] = {
        started_time: date_current_datetime(),
        current_stage: 0,
        stages: array_create(array_length(_quests.definitions[$ _quest_id].stages))
    };
    
    // Add to active quests
    ds_list_add(_quests.active, _quest_id);
    
    // Remove from available quests
    ds_list_delete(_quests.available, ds_list_find_index(_quests.available, _quest_id));
    
    // Set as tracked quest if none is tracked
    if (_quests.tracked == undefined) {
        _quests.tracked = _quest_id;
    }
    
    LogMessage(global.LogLevel.INFO, "Quest started", {
        quest: _quest_id,
        time: _quests.progress[$ _quest_id].started_time
    });
    
    return true;
}

/// @function QuestManager_UpdateProgress(quest_id, stage_id, amount)
/// @param {String} quest_id ID of the quest to update
/// @param {String} stage_id ID of the stage to update
/// @param {Real} amount Amount to progress by
/// @returns {Bool} True if stage completed
function QuestManager_UpdateProgress(_quest_id, _stage_id, _amount = 1) {
    var _quests = global.gameState.quests;
    var _quest = _quests.definitions[$ _quest_id];
    var _progress = _quests.progress[$ _quest_id];
    
    if (_progress == undefined) return false;
    
    var _current_stage = _quest.stages[_progress.current_stage];
    if (_current_stage.id != _stage_id) return false;
    
    _progress.stages[_progress.current_stage] += _amount;
    
    // Check if stage is complete
    if (_progress.stages[_progress.current_stage] >= _current_stage.required) {
        return QuestManager_AdvanceStage(_quest_id);
    }
    
    return false;
}

/// @function QuestManager_AdvanceStage(quest_id)
/// @param {String} quest_id ID of the quest to advance
/// @returns {Bool} True if quest completed
function QuestManager_AdvanceStage(_quest_id) {
    var _quests = global.gameState.quests;
    var _quest = _quests.definitions[$ _quest_id];
    var _progress = _quests.progress[$ _quest_id];
    
    _progress.current_stage++;
    
    // Check if quest is complete
    if (_progress.current_stage >= array_length(_quest.stages)) {
        return QuestManager_CompleteQuest(_quest_id);
    }
    
    LogMessage(global.LogLevel.INFO, "Quest stage advanced", {
        quest: _quest_id,
        stage: _progress.current_stage
    });
    
    return false;
}

/// @function QuestManager_CompleteQuest(quest_id)
/// @param {String} quest_id ID of the quest to complete
/// @returns {Bool} True if quest completed successfully
function QuestManager_CompleteQuest(_quest_id) {
    var _quests = global.gameState.quests;
    var _quest = _quests.definitions[$ _quest_id];
    
    // Remove from active quests
    var _active_index = ds_list_find_index(_quests.active, _quest_id);
    if (_active_index != -1) {
        ds_list_delete(_quests.active, _active_index);
    }
    
    // Add to completed quests
    ds_list_add(_quests.completed, _quest_id);
    
    // Grant rewards
    if (variable_struct_exists(_quest, "rewards")) {
        // Add coins
        if (variable_struct_exists(_quest.rewards, "coins")) {
            // Assuming we have a function to add coins
            // AddCoins(_quest.rewards.coins);
        }
        
        // Add items
        if (variable_struct_exists(_quest.rewards, "items")) {
            for (var i = 0; i < array_length(_quest.rewards.items); i++) {
                InventoryManager_AddItem(_quest.rewards.items[i]);
            }
        }
        
        // Unlock new quests
        if (variable_struct_exists(_quest.rewards, "unlocks")) {
            for (var i = 0; i < array_length(_quest.rewards.unlocks); i++) {
                _quests.flags[$ _quest.rewards.unlocks[i]] = true;
            }
        }
    }
    
    // Update available quests
    QuestManager_UpdateAvailableQuests();
    
    // Update tracked quest if needed
    if (_quests.tracked == _quest_id) {
        _quests.tracked = undefined;
    }
    
    LogMessage(global.LogLevel.INFO, "Quest completed", {
        quest: _quest_id,
        rewards: _quest.rewards
    });
    
    return true;
} 