//void, ObjList objs,point pt, Obj obj, bool bReplace, bool bModifier, int player

Unit u;
Obj cat;
ObjList builders;
int i;
int maxunits;

maxunits = GetConst("CatapultMaxUnits");

cat.Clear();
objs.ClearDead();
builders = objs.FilterClosest(pt,maxunits);
//if(builders.count < minunits) return;

cat = PlaceCatapult(pt.x, pt.y, builders[0].AsUnit().player);

for(i = 0; i < builders.count; i += 1)
{
	u = builders[i].AsUnit();
	u.SetCommand("build_catapult", cat);
	u.Deselect();
}