area["name"="Berlin"]->.region;
rel(area.region)["leisure"="park"];
map_to_area -> .parks;
node(area.parks)["leisure"="playground"];
way(area.parks)["leisure"="playground"];
out;
node(area.parks)["leisure"="playground"] -> .playgrounds;
node.playgrounds(around:500.0);
out ;
