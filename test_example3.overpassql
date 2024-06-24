area["admin_level"="4"]["name"="Hessen"]["boundary"="administrative"]->.boundaryarea;
( node(area.boundaryarea)["amenity"="fire_station"];
  way(area.boundaryarea)["amenity"="fire_station"];
  >;
) ->.a;

.a is_in -> .b; 
area.b["admin_level"="8"] -> .bf; 

rel(area.boundaryarea)["admin_level"="8"];
map_to_area -> .bllf;

(.bllf; - .bf; );
rel(pivot);
(._;>;);
out;
