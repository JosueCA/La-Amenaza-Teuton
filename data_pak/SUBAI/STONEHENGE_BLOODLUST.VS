//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Query qMages;
ObjList olMages;
int i,count;
Building this;

this = objs[0].AsBuilding();
if (!.IsValid()) return;
if (.IsSpellCasted()) return;
qMages = Intersect(ObjsInSight(this, "BaseMage"), ControllableObjs(player, "BaseMage"));
count = GetConst("StonehengeBloodlust");
if (qMages.count < count) return;

olMages.Clear();
for (i=0; i<count; i+=1) {
	olMages.Add(qMages.GetObjList()[i]);
}

olMages.SetCommand("globalspell",this);
.GlobalSpellStart(5, player); //0=invalid, 1=wind of wisdom, 2=starvation, 3=golden rain, 4= death wish, 5=bloodlust
.SetCommand("wait_for_finish_sacrifice");
