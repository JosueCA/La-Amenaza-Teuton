//bool, ObjList objs, str OUT reasonText

if(EnvReadString(objs[0].AsBuilding.settlement, cmdparam) == "researched")
	return true;
reasonText = Translatef("%s1 (Requires equipment from blacksmith)", rollover);
return false;

