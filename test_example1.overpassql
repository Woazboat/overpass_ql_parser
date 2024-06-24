area["name"="San Francisco"]->.sf;
node(area.sf)["amenity"="bicycle_rental"]->.bike_rental;
node(around.bike_rental:50)["railway"="station"]->.station;
node(around.station:50)["amenity"="bicycle_rental"]->.filtered_bicycle_rental;

(
  .filtered_bicycle_rental;
  .station;
);
out meta;
