/// @function PlayerManager_Initialize()
/// @description Initializes the player management system
function PlayerManager_Initialize() {
    global.gameState.player = {
        // Core properties
        instance: noone,
        position: { x: 0, y: 0 },
        movement: { xspd: 0, yspd: 0, move_spd: 1 },
        face: DOWN,
        
        // Visual state
        skin: "player",
        color: c_white,
        last_color: c_white,
        
        // Action state
        action: {
            current: "none",
            timer: 0,
            duration: 0,
            has_spawned_projectile: false
        },
        
        // Animation data
        animation: {
            frame_index: 0,
            speed: 0,
            frame_data: undefined,
            sprite_body: undefined,
            sprite_color: undefined
        },
        
        // State flags
        flags: {
            controls_enabled: true,
            is_sliding: false,
            is_driving: false,
            can_interact: true
        }
    };
    
    // Initialize animation frame data
    PlayerManager_InitializeAnimations();
    
    LogMessage(global.LogLevel.INFO, "PlayerManager initialized");
}

/// @function PlayerManager_InitializeAnimations()
/// @description Sets up animation data for the player
function PlayerManager_InitializeAnimations() {
    var _player = global.gameState.player;
    
    // Frame data for walking (8 directions, 3 frames each)
    _player.animation.frame_data = {
        walking: array_create(8),
        actions: ds_map_create()
    };
    
    // Walking animation frames
    _player.animation.frame_data.walking[DOWN] = [0, 0, 24, 24, 0, 24, 24, 24, 0, 48, 24, 24];
    _player.animation.frame_data.walking[UP] = [24, 0, 24, 24, 24, 24, 24, 24, 24, 48, 24, 24];
    _player.animation.frame_data.walking[DOWN_LEFT] = [48, 0, 24, 24, 48, 24, 24, 24, 48, 48, 24, 24];
    _player.animation.frame_data.walking[DOWN_RIGHT] = [72, 0, 24, 24, 72, 24, 24, 24, 72, 48, 24, 24];
    _player.animation.frame_data.walking[LEFT] = [96, 0, 24, 24, 96, 24, 24, 24, 96, 48, 24, 24];
    _player.animation.frame_data.walking[RIGHT] = [120, 0, 24, 24, 120, 24, 24, 24, 120, 48, 24, 24];
    _player.animation.frame_data.walking[UP_RIGHT] = [144, 0, 24, 24, 144, 24, 24, 24, 144, 48, 24, 24];
    _player.animation.frame_data.walking[UP_LEFT] = [168, 0, 24, 24, 168, 24, 24, 24, 168, 48, 24, 24];
    
    // Action animations
    var _actions = _player.animation.frame_data.actions;
    
    // Sit animation
    ds_map_add(_actions, "sit", {
        frames: [
            [0, 72, 24, 24], [24, 72, 24, 24], [48, 72, 24, 24], [72, 72, 24, 24],
            [96, 72, 24, 24], [120, 72, 24, 24], [144, 72, 24, 24], [168, 72, 24, 24]
        ],
        speed: 0,
        loop: false,
        sprite_body: "spr_player_body",
        sprite_color: "spr_player_colour"
    });
    
    // Wave animation
    ds_map_add(_actions, "wave", {
        frames: [
            [0, 96, 24, 24], [24, 96, 24, 24], [48, 96, 24, 24], [72, 96, 24, 24],
            [96, 96, 24, 24], [120, 96, 24, 24], [144, 96, 24, 24], [168, 96, 24, 24]
        ],
        speed: 0.1,
        loop: true,
        sprite_body: "spr_player_body",
        sprite_color: "spr_player_colour"
    });
    
    // Add other action animations similarly...
}

/// @function PlayerManager_Update()
/// @description Updates player state and animations
function PlayerManager_Update() {
    var _player = global.gameState.player;
    if (!instance_exists(_player.instance)) return;
    
    var _inst = _player.instance;
    
    // Update position
    _player.position.x = _inst.x;
    _player.position.y = _inst.y;
    
    // Handle movement if not in action
    if (_player.action.current == "none" && _player.flags.controls_enabled) {
        PlayerManager_HandleMovement();
    }
    
    // Update action state
    if (_player.action.current != "none") {
        PlayerManager_UpdateAction();
    }
    
    // Update animation
    PlayerManager_UpdateAnimation();
}

/// @function PlayerManager_HandleMovement()
/// @description Handles player movement input and physics
function PlayerManager_HandleMovement() {
    var _player = global.gameState.player;
    var _inst = _player.instance;
    
    // Get input
    var _right = keyboard_check(ord("D")) || keyboard_check(vk_right);
    var _left = keyboard_check(ord("A")) || keyboard_check(vk_left);
    var _up = keyboard_check(ord("W")) || keyboard_check(vk_up);
    var _down = keyboard_check(ord("S")) || keyboard_check(vk_down);
    
    // Calculate movement
    var _move_x = (_right - _left) * _player.movement.move_spd;
    var _move_y = (_down - _up) * _player.movement.move_spd;
    
    // Apply sliding if active
    if (_player.flags.is_sliding) {
        // Sliding physics calculation here
    }
    
    // Update facing direction
    if (_move_x != 0 || _move_y != 0) {
        _player.face = PlayerManager_CalculateFacing(_move_x, _move_y);
    }
    
    // Apply movement with collision
    _inst.xspd = _move_x;
    _inst.yspd = _move_y;
    
    // Store movement state
    _player.movement.xspd = _move_x;
    _player.movement.yspd = _move_y;
}

/// @function PlayerManager_StartAction(action_name)
/// @param {String} action_name Name of the action to start
/// @returns {Bool} True if action started successfully
function PlayerManager_StartAction(_action_name) {
    var _player = global.gameState.player;
    
    // Check if action exists
    if (!ds_map_exists(_player.animation.frame_data.actions, _action_name)) {
        LogMessage(global.LogLevel.ERROR, "Invalid action name", _action_name);
        return false;
    }
    
    // Check if action is allowed
    if (!_player.flags.controls_enabled) return false;
    
    // Get action data
    var _action_data = _player.animation.frame_data.actions[? _action_name];
    
    // Start action
    _player.action.current = _action_name;
    _player.action.timer = 0;
    _player.action.has_spawned_projectile = false;
    _player.animation.frame_index = 0;
    _player.animation.speed = _action_data.speed;
    
    LogMessage(global.LogLevel.INFO, "Started player action", _action_name);
    return true;
}

/// @function PlayerManager_UpdateAction()
/// @description Updates current player action state
function PlayerManager_UpdateAction() {
    var _player = global.gameState.player;
    var _action_data = _player.animation.frame_data.actions[? _player.action.current];
    
    // Update action timer
    _player.action.timer++;
    
    // Check for action completion
    if (_action_data.loop == false) {
        if (_player.animation.frame_index >= array_length(_action_data.frames)) {
            PlayerManager_EndAction();
        }
    }
}

/// @function PlayerManager_EndAction()
/// @description Ends the current player action
function PlayerManager_EndAction() {
    var _player = global.gameState.player;
    
    _player.action.current = "none";
    _player.action.timer = 0;
    _player.action.has_spawned_projectile = false;
    _player.animation.frame_index = 0;
    _player.animation.speed = 0;
}

/// @function PlayerManager_CalculateFacing(move_x, move_y)
/// @param {Real} move_x Horizontal movement
/// @param {Real} move_y Vertical movement
/// @returns {Real} The calculated facing direction
function PlayerManager_CalculateFacing(_move_x, _move_y) {
    if (_move_y < 0) {
        if (_move_x < 0) return UP_LEFT;
        if (_move_x > 0) return UP_RIGHT;
        return UP;
    }
    if (_move_y > 0) {
        if (_move_x < 0) return DOWN_LEFT;
        if (_move_x > 0) return DOWN_RIGHT;
        return DOWN;
    }
    if (_move_x > 0) return RIGHT;
    if (_move_x < 0) return LEFT;
    
    return global.gameState.player.face;
} 