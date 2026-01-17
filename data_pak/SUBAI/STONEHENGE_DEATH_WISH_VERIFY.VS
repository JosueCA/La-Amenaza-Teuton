//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();
if (!.IsValid()) return false;
if (.IsSpellCasted()) {
	reasonText=Translate("You must wait for the current ritual to be completed");
	return false;
}
if (.CountMages() >= GetConst("StonehengeFinalSacrifice")) return true;

reasonText = Translatef("%s1 (%s2 druids or priests required)", rollover, GetConst("StonehengeFinalSacrifice"));
return false;
