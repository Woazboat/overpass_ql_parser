convert rel ::id = 1, foo = "bar";

convert rel ::id = _.u(id()),
             wikidata = _.u(t["wikidata"]),
             all_relation_ids = d.set( id() );

convert node ::=::,
              ::id = id(),
              is_in=a.set("{" + t["admin_level"] + ":" + t["name"] + "}");

convert way ::=::,
              ::id = id(),
              is_in=a.set("{" + t["admin_level"] + ":" + t["name"] + "}");

convert node
  ::id=id(), 
  older365=date(t["check_date"])<date("{{date:365days}}");
