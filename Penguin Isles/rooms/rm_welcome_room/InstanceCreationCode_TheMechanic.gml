npc_name = "The Mechanic";
npc_color = c_black;  // Black
is_quest_giver = true;
quest_id = 1;
dialog_data = [
    {
        text: "Hello, I need help finding my wrench.",
        choices: ["Sure, I'll help.", "Maybe later."],
        quest: { id: 1, action: "start" }
    },
    {
        text: "Did you find my wrench?",
        choices: ["Yes, here it is.", "Not yet."],
        quest: { id: 1, action: "complete" }
    }
];
quest_item = "Wrench";
quest_stage = 0;