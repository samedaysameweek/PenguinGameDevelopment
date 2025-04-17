// Ensure player is near and pressing "R" to repair
if (keyboard_check_pressed(ord("R")) && instance_exists(obj_player) && distance_to_object(obj_player) < 16) {
    // Check inventory using the centralized method
    if (instance_exists(obj_inventory) && (obj_inventory.inventory_has("Wrench") || obj_inventory.inventory_has("Battery"))) {

        show_debug_message("Repairing ice truck...");

        // NOTE: Item removal should ideally happen *here* or be triggered by the truck becoming obj_icetruck
        // We'll leave the removal logic in obj_inventory's Step for now based on global.repair_complete,
        // but ideally, the truck itself should signal which item was consumed.
        // For now, we set the flag that obj_inventory looks for.
        global.repair_complete = true;
         show_debug_message("DEBUG: Setting global.repair_complete = true in obj_icetruck_broken");


        // Destroy the broken truck
        instance_destroy();

        // Replace with repaired version
        var new_truck = instance_create_layer(x, y, "Instances", obj_icetruck);
        new_truck.repair_required = false;
        // new_truck.repair_complete = true; // Redundant if global flag is used
        new_truck.is_driveable = true;

        // Prevent instant entry
        // global.repair_cooldown = true; // Manage cooldown if needed
        // alarm[0] = 30;

        show_debug_message("Ice truck repaired! It is now driveable.");

    } else {
        show_debug_message("You need a Wrench or a Battery to repair this!");
        if (instance_exists(obj_inventory)) {
            show_debug_message("Has Wrench: " + string(obj_inventory.inventory_has("Wrench"))); // Use new method
            show_debug_message("Has Battery: " + string(obj_inventory.inventory_has("Battery"))); // Use new method
        } else {
             show_debug_message("ERROR: obj_inventory instance not found for repair check!");
        }
    }
}
// Ensure correct depth
set_depth();