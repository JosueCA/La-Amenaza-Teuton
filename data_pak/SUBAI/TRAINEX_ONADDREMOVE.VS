// bool, Obj This, bool bAdd  
int number, maxnumber, queued, curnmb;
str class, groupname, dest, research; 
Building this;

this = This.AsBuilding;
dest = cmdparam;

number = Str2Int(ParseStr(dest, dest));
maxnumber = Str2Int(ParseStr(dest, dest));
class = ParseStr(dest, dest);
groupname = ParseStr(dest, dest);

queued = EnvReadInt(this, "QueuedBuild/"+class);
if(bAdd)
{
  curnmb = GetGroupSize("Player"+.player+groupname) + number + EnvReadInt(this, "Build/"+class) + queued;
	if(curnmb > maxnumber)
	{
		return false;
	} else
	{
		EnvWriteInt(this, "QueuedBuild/"+class, queued + number);
		return true;
	}
}
else
{
	EnvWriteInt(this, "QueuedBuild/"+class, queued - number);
	return true;
}
return true;