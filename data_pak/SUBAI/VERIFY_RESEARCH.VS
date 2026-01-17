//bool, ObjList objs, str OUT reasonText
// cmdparam is like this ReqSet, <research>, <explanation>, ReqPlr, <research>, <explanation>, SetsPlr, <env>, <value>, SetsSet, <env>, <value>, NamePlr, <research>, NameSet, <research>

Building this;
str dest, name, token, value;
dest = cmdparam;
this = objs[0].AsBuilding();

while(dest != "")
{
	token = ParseStr(dest, dest);
	if(token == "NameSet")
	{
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
/*		if(EnvReadString(.settlement, name) == "researching")
		{
			//reasonText = Translatef("%s1 is researching", name);
			reasonText = rollover;
			return false;
		}*/
		if(EnvReadString(.settlement, name) == "researched")
		{
			if(value == "default")
				reasonText = Translatef("%s1 available", name);
			else
				reasonText = value;
			return false;
		}
		if(this.AsBuilding.IsValid)
		if(EnvReadString(this, "researching") == "yes")
		{
			reasonText = rollover;
			return false;
		}
	}	
	if(token == "NamePlr")
	{
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
/*		if(EnvReadString(.player, name) == "researching")
		{
			//reasonText = Translatef("%s1 is researching", name);
			reasonText = rollover;
			return false;
		}*/
		if(EnvReadString(.player, name) == "researched")
		{
			if(value == "default")
				reasonText = Translatef("%s1 available", name);
			else
				reasonText = value;
			return false;
		}
		if(this.AsBuilding.IsValid)
		if(EnvReadString(this, "researching") == "yes")
		{
			reasonText = rollover;
			return false;
		}
	}
	if(token == "ReqSet")
	{
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if(EnvReadString(.settlement, name) != "researched")
		{
			if(value == "default")
				reasonText = Translatef("%s1 (requires %s2)", rollover, name);
			else
				reasonText = value;
			return false;
		}
		continue;
	} 
	if(token == "ReqPlr")
	{
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if(EnvReadString(.player, name) != "researched")
		{
			if(value == "default")
				reasonText = Translatef("%s1 (requires %s2)", rollover, name);
			else
				reasonText = value;
			return false;
		}
		continue;
	}
}
return true;
