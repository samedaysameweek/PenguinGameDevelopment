/// Step Event for obj_warp_block - REVISED WARP LOGIC + DEBUG

   if (instance_exists(obj_warp) || global.warp_cooldown) {
       // Add a log if player is colliding but cooldown is active
       if (global.warp_cooldown && instance_exists(global.player_instance) && place_meeting(x, y, global.player_instance)) {
           show_debug_message("DEBUG Warp Block: Player colliding but global.warp_cooldown is TRUE.");
       }
       exit;
   }

    var _warp_instance = noone; var _warp_target_face = target_face;
    if (instance_exists(global.player_instance)) {
    // --- DEBUG: Log player position and warp block bounds ---
    var _player_x = global.player_instance.x;
    var _player_y = global.player_instance.y;
    var _block_bbox_left = bbox_left;
    var _block_bbox_right = bbox_right;
    var _block_bbox_top = bbox_top;
    var _block_bbox_bottom = bbox_bottom;
    // show_debug_message("Warp Block Check: Player ("+string(global.player_instance)+") at ("+string(_player_x)+","+string(_player_y)+"). Block Bounds: L"+string(_block_bbox_left)+" R"+string(_block_bbox_right)+" T"+string(_block_bbox_top)+" B"+string(_block_bbox_bottom));

    if (place_meeting(x,y,global.player_instance)) { // Check collision using block's coords
         // --- DEBUG: Log successful collision ---
         show_debug_message("Warp Block Check: place_meeting with Player TRUE. Cooldown: " + string(global.warp_cooldown));

         _warp_instance=global.player_instance;
         if (variable_instance_exists(global.player_instance, "face")) {
              _warp_target_face = global.player_instance.face;
         }
          show_debug_message("DEBUG: Player (" + string(_warp_instance) + ", Skin: " + global.current_skin + ") detected. Prioritizing warp.");
    } else {
         // --- DEBUG: Log failed collision ---
          // show_debug_message("Warp Block Check: place_meeting with Player FALSE.");
    }
}

// --- Check Polar Bear Collision (ONLY IF PLAYER IS NOT WARPING) ---
if (_warp_instance == noone) { 
	var _c_b = instance_place(x,y,obj_polarbear); if(_c_b != noone) {
        _warp_instance = _c_b;
        _warp_target_face = _c_b.current_direction; // Use bear's direction
        show_debug_message("DEBUG: Polar Bear (" + string(_warp_instance) + ") detected on obj_warp_block. Warping.");
    }
}

// --- Check OLD NPC Collision (ONLY IF PLAYER/BEAR ARE NOT WARPING) ---
// Add similar blocks for obj_npc_old or other specific NPCs if needed
if (_warp_instance == noone) {
    var _colliding_npc_old = instance_place(x, y, obj_npc_old);
    if (_colliding_npc_old != noone) {
         _warp_instance = _colliding_npc_old;
         _warp_target_face = _colliding_npc_old.face; // Use NPC's face
         show_debug_message("DEBUG: obj_npc_old (" + string(_warp_instance) + ") detected on obj_warp_block. Warping.");
    }
}


// --- Create Warp Instance IF a target was found ---
if (_warp_instance != noone) {
    show_debug_message("Creating obj_warp for instance: " + string(_warp_instance) + " (" + object_get_name(_warp_instance.object_index) + ")");
    var inst = instance_create_depth(0, 0, -9999, obj_warp);

    // Pass the specific instance and details to the warp object
    inst.target_rm = self.target_rm;
    inst.target_x = self.target_x;
    inst.target_y = self.target_y;
    inst.target_face = _warp_target_face; // Use the determined face
    inst.target_instance = _warp_instance; // *** STORE THE SPECIFIC INSTANCE ***

    global.warp_cooldown = true; // Set cooldown AFTER successfully creating warp

    show_debug_message("Warping instance " + string(_warp_instance) + " to Room: " + room_get_name(inst.target_rm) +
        " Pos: (" + string(inst.target_x) + ", " + string(inst.target_y) + ") Facing: " + string(inst.target_face));
}