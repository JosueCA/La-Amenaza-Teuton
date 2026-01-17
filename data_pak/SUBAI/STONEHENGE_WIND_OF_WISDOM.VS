//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player


Query qMages;
ObjList olMages;
int i;
Building this;

this = objs[0].AsBuilding();
if (!.IsValid()) return;
if (.IsSpellCasted()) return;
qMages = Intersect(ObjsInSight(this, "BaseMage"), ControllableObjs(player, "BaseMage"));

if (!qMages.IsEmpty()) {
	.WindOfWisdom(qMages.count);
	qMages.Damage(100000); 
}