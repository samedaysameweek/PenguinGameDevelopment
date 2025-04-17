// Sprite definitions
sprite_base = spr_icetruck_base_empty_repairable;
sprite_colour = spr_icetruck_colour;
sprite_window = spr_icetruck_window;
icetruck_tint = c_yellow; // Default tint, consistent with obj_player_icetruck
mask_index = spr_icetruck_facedown; // For collision detection

// Existing state variables
repair_required = true;
repair_complete = false;
global.repair_complete = false;
is_driveable = false;

alarm[1] = 5; // Keep the repair flag active for 5 frames
is_savable = true;