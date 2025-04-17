/// Step Event for obj_warp_block

// Handle Player Warping
if (instance_exists(global.player_instance) && place_meeting(x, y, global.player_instance) && !instance_exists(obj_warp)) 
{
    show_debug_message("DEBUG: obj_player detected on obj_warp_block. Warping...");
    
    var inst = instance_create_depth(0, 0, -9999, obj_warp);
    inst.target_x = self.target_x;   // Ensure correct target coordinates
    inst.target_y = self.target_y;
    inst.target_rm = self.target_rm;
    inst.target_face = self.target_face;
    inst.target_instance = global.player_instance; // Use global instance of player
	
}

// Handle Ice Truck Warping
if (instance_exists(obj_player_icetruck) && place_meeting(x, y, obj_player_icetruck) && !instance_exists(obj_warp)) 
{
    var inst = instance_create_depth(0, 0, -9999, obj_warp);
    inst.target_x = self.target_x;
    inst.target_y = self.target_y;
    inst.target_rm = self.target_rm;
    inst.target_face = obj_player_icetruck.face;
    inst.target_instance = instance_find(obj_player_icetruck, 0);

}

/// Step Event for obj_warp_block

// Handle Player Warping
if (instance_exists(global.player_instance) && place_meeting(global.player_instance.x, global.player_instance.y, id) && !instance_exists(obj_warp)) 
{
    show_debug_message("DEBUG: obj_player_tube detected on obj_warp_block. Warping...");

    var inst = instance_create_depth(0, 0, -9999, obj_warp);
    inst.target_x = self.target_x;   // Correctly assign the warp block's values
    inst.target_y = self.target_y;
    inst.target_rm = self.target_rm;
    inst.target_face = self.target_face;
    inst.target_instance = global.player_instance;

    // Debugging output to confirm correct values are passed
    show_debug_message("Warping obj_player_tube to Room: " + string(inst.target_rm) +
        " Position: (" + string(inst.target_x) + ", " + string(inst.target_y) + ") Facing: " + string(inst.target_face));
}



// Handle NPC Warping
if (instance_exists(obj_npc_old) && place_meeting(x, y, obj_npc_old) && !instance_exists(obj_warp)) 
{
    var inst = instance_create_depth(0, 0, -9999, obj_warp);
    inst.target_x = self.target_x;
    inst.target_y = self.target_y;
    inst.target_rm = self.target_rm;
    inst.target_face = obj_npc_old.face;
    inst.target_instance = instance_find(obj_npc_old, 0);

}

if (!global.warp_cooldown && instance_exists(global.player_instance) && place_meeting(global.player_instance.x, global.player_instance.y, id) && !instance_exists(obj_warp)) 
{
    var inst = instance_create_depth(0, 0, -9999, obj_warp);
    inst.target_x = self.target_x;
    inst.target_y = self.target_y;
    inst.target_rm = self.target_rm;
    inst.target_face = self.target_face;
    inst.target_instance = global.player_instance;
}

