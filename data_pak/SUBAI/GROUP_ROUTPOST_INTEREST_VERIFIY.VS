//bool, ObjList objs, str OUT reasonText

Building this;
str strEnvStr;

if(objs.count > 0)
{
	this = objs[0].AsBuilding();
	if(.IsValid())
	{
		strEnvStr = EnvReadString(.settlement, "ROutpostInterest");
		if(strEnvStr != "yes") return true;
	}
}
return false;
