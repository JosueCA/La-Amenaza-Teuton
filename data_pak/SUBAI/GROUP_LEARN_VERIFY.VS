//bool, ObjList objs, str OUT reasonText

if(EnvReadString(objs[0].player, "learn") == "researched")
	return true;

reasonText = rollover;
return false;

