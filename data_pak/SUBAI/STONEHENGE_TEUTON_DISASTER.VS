//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player


Query qMages;
ObjList olMages;
int i,count;
Building this;

this = objs[0].AsBuilding();
if (!.IsValid()) return;
if (.IsSpellCasted()) return;
qMages = Intersect(ObjsInSight(this, "BaseMage"), ControllableObjs(player, "BaseMage"));
count = GetConst("StonehengeTeutonDisaster");
if (qMages.count < count) return;

olMages.Clear();
for (i=0; i<count; i+=1) {
	olMages.Add(qMages.GetObjList()[i]);
}

olMages.SetCommand("globalspell", this);
.GlobalSpellStart(6, player); //6=teuton disaster
.SetCommand("wait_for_finish_sacrifice");
