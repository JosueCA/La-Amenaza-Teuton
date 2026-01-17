//bool, ObjList objs, str OUT reasonText

Obj this;
int i;
str dest, name, reason;
this = objs[0];
dest = cmdparam;

name = ParseStr(dest, dest);
reason = ParseStr(dest, dest);
if (reason == "") reason = "%s1 (requires %s2)";
if(EnvReadString(.player, name) != "researched")
	if(this.AsBuilding.IsValid)
	{
		if(EnvReadString(this.AsBuilding.settlement, name) != "researched")
		{
			reasonText = Translatef(reason, rollover, name);
			return false;
		}
	} else
	{
		reasonText = Translatef(reason, rollover, name);
		return false;
	}
return true;