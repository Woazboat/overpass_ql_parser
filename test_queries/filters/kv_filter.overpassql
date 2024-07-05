// kv filter test
node["foo"][!"bar"];
node[~"foo"][!~"bar"];
node["key"="value"]["key"!="value"];
node[!"key"="value"][!"key"!="value"];
node["key"~"value"][~"key"~"value"];
node[!"key"~"value"][!~"key"~"value"];
node["key"!~"value"][~"key"!~"value"];
node[!"key"!~"value"][!~"key"!~"value"];


// case insensitivity
node["foo",i][!"bar",i];
node[~"foo",i][!~"bar",i];
node["key"="value",i]["key"!="value",i];
node[!"key"="value",i][!"key"!="value",i];
node["key"~"value",i][~"key"~"value",i];
node[!"key"~"value",i][!~"key"~"value",i];
node["key"!~"value",i][~"key"!~"value",i];
node[!"key"!~"value",i][!~"key"!~"value",i];
