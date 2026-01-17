//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;
ObjList lst;
ObjList l;
int i;
Unit u;


if(objs.count() != 1) return;
this = objs[0].AsBuilding();
lst = .settlement.Units();

for(i = 0; i < lst.count(); i = i + 1) {
	u = lst[i].AsUnit();
	if(u.IsValid()) {
		if(!u.hero().IsValid()) {
			l.Add(u);
		}
	}
}

ClearSelection(.player);
for(i = 0; i < l.count(); i = i + 1) {
	l[i].Select(.player);
}

l.ExecDefaultCmd(pt,obj,bReplace,bModifier);


