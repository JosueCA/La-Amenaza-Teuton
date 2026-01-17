//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Query qMages;
ObjList olMages;
int i,count;
Building this;

this = objs[0].AsBuilding();
if (!.IsValid()) return;
if (.IsSpellCasted()) return;
qMages = Intersect(ObjsInSight(this, "BaseMage"), ControllableObjs(player, "BaseMage"));
count = GetConst("StonehengeFinalSacrifice");
if (qMages.count < count) return;

olMages.Clear();
for (i=0; i<count; i+=1) {
	Obj u;
	u = qMages.GetObjList()[i];
	olMages.Add(u);
	u.AsDruid().SetStonehenge(this);
}

olMages.SetCommand("globalspell", this);
.GlobalSpellStart(4, player); //4= death wish
.SetCommand("wait_for_finish_sacrifice");
