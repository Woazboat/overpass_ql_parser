make node "foo"="bar";

make x name=_.val;

make count "de:regionalschluessel" = regio.set(t[ "de:regionalschluessel"]),
             name = regio.set(t["name"]),
             total = count(nodes) + count(ways) + count(relations),
             nodes = count(nodes),
             ways = count(ways),
             relations = count(relations);

make stat number=count(ways),length=sum(length());

make stats length=sum(length()) /* meters */;

// Output the distance from the route’s starting point to the exit.
make stats length=sum(length());

make stat version=u(version()),timestamp=u(timestamp()),changeset=u(changeset());

make stat version=u(version()),timestamp=u(timestamp()),changeset=u(changeset()),count=u(count_members());


make out _row = "{|class=wikitable    "; out;
make out _row = "|-                   "; out;
make out _row = "! Regional Key       "; out;
make out _row = "! Name               "; out;
make out _row = "! Total              "; out;
make out _row = "! Nodes              "; out;
make out _row = "! Ways               "; out;
make out _row = "! Relations          "; out;
  
  make out _row = "|-"; out;
  make out _row = "| " + regio.set(t[ "de:regionalschluessel"]) + 
                  " || " + regio.set(t["name"]) + 
                  " || " + (r.count(nodes) + r.count(ways) + r.count(relations)) + 
                  " || " + r.count(nodes) + 
                  " || " + r.count(ways) +
                  " || " + r.count(relations); 
  out;

make out _row = "|}"; out;
