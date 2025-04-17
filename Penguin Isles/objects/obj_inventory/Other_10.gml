// --- obj_inventory: User Event 0 ---
// This event is triggered when inventory changes (add/remove).
// Quest system or other listeners can check inventory state here.
// show_debug_message("Inventory User Event 0 Triggered: Inventory Changed.");

// Example: Notify a Quest Manager (if one exists)
// if (instance_exists(obj_quest_manager)) {
//     obj_quest_manager.check_collect_objectives();
// }