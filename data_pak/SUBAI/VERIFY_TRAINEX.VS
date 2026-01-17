//bool, ObjList objs, str OUT reasonText

int numbertotrain, maxnumber, curnmb, queued;
str class, group, dest, research; 
Query qGroup;

Building this;


this = objs[0].AsBuilding;


dest = cmdparam;

numbertotrain = Str2Int(ParseStr(dest, dest));
maxnumber = Str2Int(ParseStr(dest, dest));
class = ParseStr(dest, dest);
group = ParseStr(dest, dest);
research = ParseStr(dest, dest);

	 
if(EnvReadString(.settlement, research) != "researched" &&
  EnvReadString(.player, research) != "researched" )
{
	reasonText = Translatef("%s1 (requires %s2)", rollover, research);
	return false;
}

queued = EnvReadInt(this, "QueuedBuild/"+class);
curnmb = GetGroupSize("Player"+.player+group) + numbertotrain + EnvReadInt(this, "Build/"+class) + queued;

if (curnmb > maxnumber)
{
   reasonText = Translate("No more available");
   return false;
}
return true;