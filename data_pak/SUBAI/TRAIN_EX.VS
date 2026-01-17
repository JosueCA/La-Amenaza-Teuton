// void, Obj This

// this script train number of units, adds them to a group
// parm="numbertotrain, maxnumber, class, grouptoadd"

Building this;
str dest;
int numbertotrain, maxnumber;
str class, grouptoadd;


dest = cmdparam;

numbertotrain = Str2Int(ParseStr(dest, dest));
maxnumber = Str2Int(ParseStr(dest, dest));
class = ParseStr(dest, dest);
grouptoadd = ParseStr(dest, dest);

this = This.AsBuilding();

.Progress(.cmddelay);

EnvWriteString(this, "Build", class);
EnvWriteString(this, "BuildGroup", grouptoadd);
EnvWriteInt(this, "Build/"+class, numbertotrain);
EnvWriteInt(this, "Build/"+class+"maxnumber", maxnumber);
EnvWriteInt(this, "QueuedBuild/"+class, EnvReadInt(this, "QueuedBuild/"+class) - numbertotrain);
