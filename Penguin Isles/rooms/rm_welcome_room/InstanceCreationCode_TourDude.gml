npc_name = "TourDude";
npc_color = make_color_rgb(8, 153, 211);  // Light Blue
is_static = true;
dialog_data = [
    {text: "Welcome to Penguin Isles! I’m TourDude.", condition: method(self, function() { return true; })},
    {text: "Let me show you around. First, the Town!", condition: method(self, function() { return true; })},
    {text: "Here’s the Ski Village, great for sledding!", condition: method(self, function() { return true; })},
    {text: "The Plaza has fun activities. Enjoy!", condition: method(self, function() { return true; })},
    {text: "That’s it for now. I’ll see you later… maybe!", condition: method(self, function() { return true; })}
];
is_quest_giver = false;