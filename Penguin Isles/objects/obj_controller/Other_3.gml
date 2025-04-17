function cleanup_game() {
if (ds_exists(global.room_states, ds_type_map)) {
    ds_map_destroy(global.room_states);
}
if (ds_exists(global.following_puffles, ds_type_list)) {
    ds_list_destroy(global.following_puffles);
}
if (ds_exists(global.active_quests, ds_type_list)) {
    ds_list_destroy(global.active_quests);
}
if (ds_exists(global.completed_quests, ds_type_list)) {
    ds_list_destroy(global.completed_quests);
}
if (ds_exists(global.quest_progress, ds_type_map)) {
    ds_map_destroy(global.quest_progress);
}
if (ds_exists(global.quest_definitions, ds_type_map)) {
    ds_map_destroy(global.quest_definitions);
}
// Add destruction for other global data structures used in your project
}