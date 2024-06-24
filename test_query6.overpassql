node(way_cnt:2);    // select those nodes that are members of exactly two of the given ways
node(way_cnt:3-4);  // select those nodes that are members of three to four of the given ways
node(way_cnt:2-);   // select those nodes that are members of two or more of the given ways
node(way_link:1);    // select those nodes that are members of exactly one segment of the given ways, i.e. are dead ends
node(way_link:4-5);  // select those nodes that are members of four to five segments of the given ways
node(way_link:3-);   // select those nodes that are members of three or more segments of the given ways, i.e. crossings
node(way_link.foo:3-);   // select those crossing nodes based on the way grid in set foo
node(way_link.foo:3-5);
