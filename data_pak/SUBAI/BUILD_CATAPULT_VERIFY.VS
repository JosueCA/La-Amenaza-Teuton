//bool, ObjList objs, str OUT reasonText

ObjList builders;
int minunits;
builders = _GetSelection().GetCanExecCmd("build_catapult");
builders.ClearDead();

minunits = GetConst("CatapultBuildUnits");

if(builders.count < minunits)
{
	reasonText = Translate("You need to select more units to build catapult");
	return false;
}
return true;