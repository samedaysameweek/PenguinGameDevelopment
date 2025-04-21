// obj_polarbear Create Event
xspd = 0;
yspd = 0;
move_spd = 0.5; // SLOWER walking speed
face = PB_DOWN; // Use macro for initial face if needed, but 'face' isn't used by polar bear directly anymore
mood = "passive"; // Start in passive mood
throw_timer = 0;
throw_duration = 96; // Duration of throw animation
throw_frame_duration = 4; // Frames per subimage in throw sheet? Seems fast. Let's keep for now.
throw_interval = 120; // Cooldown between throws
throw_interval_timer = 0;
view_range = 100;
attack_distance = 50;
is_savable = true;
frame_w = 48;
frame_h = 48;

// -- NEW Animation Variables --
walk_anim_speed = 0.5; // SLOWER animation speed (adjust as needed)
idle_anim_speed = 0;   // Idle animation speed (0 for static face)
image_index = 0;       // Current animation frame index
image_speed = 0;       // GMS built-in animation speed control

throw_sprite = noone; // Determined in Step event now

wander_timer = 0; // Timer for wandering direction
stop_timer = 0; // Timer for stopping
is_stopped = false; // Whether the bear is stopped
dist_to_player = 1000; // Initial distance to player

// REMOVED Enum definition here

current_direction = PB_DOWN; // Use Macro for Default direction

// -- NEW: Spritesheet Mapping --
walk_frame_sheets = array_create(8);
walk_frame_sheets[PB_DOWN] = spr_polarbear_walkdown_sheet;
walk_frame_sheets[PB_DOWN_LEFT] = spr_polarbear_walkdownleft_sheet;
walk_frame_sheets[PB_LEFT] = spr_polarbear_walkleft_sheet;
walk_frame_sheets[PB_UP_LEFT] = spr_polarbear_walkupleft_sheet;
walk_frame_sheets[PB_UP] = spr_polarbear_walkup_sheet;
// Right-facing directions will use left-facing sheets and be flipped
walk_frame_sheets[PB_DOWN_RIGHT] = spr_polarbear_walkdownleft_sheet; // Uses down-left sheet
walk_frame_sheets[PB_RIGHT] = spr_polarbear_walkleft_sheet; // Uses left sheet
walk_frame_sheets[PB_UP_RIGHT] = spr_polarbear_walkupleft_sheet; // Uses up-left sheet

// -- Collision Mask Update --
mask_index = spr_polarbear_down; // Use the new specified sprite

set_depth(); // Call set_depth script