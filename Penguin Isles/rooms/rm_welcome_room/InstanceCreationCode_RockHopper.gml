npc_name = "RockHopper";
npc_color = make_color_rgb(255, 0, 0);  // Red
is_quest_giver = true;
quest_id = 1;
dialog_data = [
 {
        text: "Argh! I need some wood to fix me ship.",
        choices: ["Sure, I'll help.", "Maybe later."],
        quest: { id: 1, action: "start" }
    },
    {
        text: "Got the wood yet, matey?",
        choices: ["Yes, here it is.", "Not yet."],
        quest: { id: 1, action: "complete" }
    }
];
quest_stage = 0;
quest_item = "Wood";
quest_quantity = 1;
reward_item = "Jackhammer";