//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();
if (!.IsValid()) return false;
if (.IsSpellCasted()) {
	reasonText=Translate("You must wait for the current ritual to be completed");
	return false;
}
if (.CountMages() > 0) return true;

reasonText = Translatef("%s1 (At least one druid or priest required)", rollover);
return false;
