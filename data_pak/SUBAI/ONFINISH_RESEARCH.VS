// void, Obj This, bool bCanceled
// cmdparam is like this ReqSet, <research>, ReqPlr, <research>, SetsPlr, <env>, <value>, SetsSet, <env>, <value>, NamePlr, <research>, NameSet, <research>

Building this;
str dest, name, token, value;
dest = cmdparam;
this = This.AsBuilding();
EnvWriteString(this, "researching", "no");
while(dest != "")
{
	token = ParseStr(dest, dest);
	if(token == "NamePlr")
	if(bCanceled)
	{
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		EnvWriteString(.player, name, "");
		continue;
	} else
	{
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		EnvWriteString(.player, name, "researched");
		// Battle tactics implementation
		if (name == "Battle tactics")
			SetExperienceModifier(.player, 101);
		// Buy map implementation
		if (name == "Buy map")
			ExploreCircle(.player, .pos, 16000);
		continue;
	}
	if(token == "NameSet")
	if(bCanceled)
	{
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		EnvWriteString(.settlement, name, "");
		continue;
	}  else
	{
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		EnvWriteString(.settlement, name, "researched");
		// Food Tax implementation
		if (name == "Food Tax")
			.settlement.SetFoodProduction(GetConst("StrongholdFoodProduction"));
		continue;
	}
	if(token == "SetsPlr" && !bCanceled)
	{
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		EnvWriteString(.player, name, value);
		continue;
	}
	if(token == "SetsSet" && !bCanceled)
	{
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		EnvWriteString(.settlement, name, value);
		continue;
	}
}
