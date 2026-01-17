//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();
if (!.IsValid()) return false;

if (NoTents()) {
	reasonText=Translate("There are no Teuton tents on the map");
	return false;
}

if (.IsSpellCasted()) {
	reasonText=Translate("You must wait for the current ritual to be completed");
	return false;
}
if (.CountMages() >= GetConst("StonehengeTeutonDisaster")) return true;

reasonText = Translatef("%s1 (%s2 druids or priests required)", rollover, GetConst("StonehengeTeutonDisaster"));
return false;
