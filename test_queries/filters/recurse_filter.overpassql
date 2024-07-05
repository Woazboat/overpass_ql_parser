// Recurse member filter

node(w);            // select child nodes from ways in the input set
node(r);            // select node members of relations in the input set
way(bn);            // select parent ways for nodes in the input set
way(r);             // select way members of relations in the input set
rel(bn);            // select relations that have node members in the input set
rel(bw);            // select relations that have way members in the input set
rel(r);             // select relation members of relations in the input set
rel(br);            // select parent relations from relations in the input set

 node(w.foo);        // select child nodes from ways in the "foo" input set

node(r:"role");     // select node members of relations in the input set
way(r:"role");      // select way members of relations in the input set
rel(bn:"role");     // select relations that have node members in the input set
rel(bw:"role");     // select relations that have way members in the input set
rel(r:"role");      // select relation members of relations in the input set
rel(br:"role");     // select parent relations from relations in the input set

node(r.foo:"role"); // select node members with role "role" of relations in the "foo" input set

node(r:"");         // select node members with empty role of relations in the input set
node(r.foo:"");     // select node members with empty role of relations in the "foo" input set

// Invalid
// rel(n);


// Recurse way filter

node(way_cnt:2);    // select those nodes that are members of exactly two of the given ways
node(way_cnt:3-4);  // select those nodes that are members of three to four of the given ways
node(way_cnt:2-);   // select those nodes that are members of two or more of the given ways
node(way_link:1);    // select those nodes that are members of exactly one segment of the given ways, i.e. are dead ends
node(way_link:4-5);  // select those nodes that are members of four to five segments of the given ways
node(way_link:3-);   // select those nodes that are members of three or more segments of the given ways, i.e. crossings

node(way_link.foo:3-);   // select those crossing nodes based on the way grid in set foo
