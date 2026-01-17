//void, Obj This

Catapult this;
point ptBase, pt;
ObjList units;
int i;

this = This.AsCatapult();
units = .settlement().Units();

ptBase = .CalcEscapeDirection();
ptBase.SetLen( .radius * 4);

for(i = 0; i < units.count(); i = i + 1)
{
	pt= ptBase;
	pt.Rot(30-rand(60));
	units[i].ClearCommands();
	units[i].AddCommand(false,"move",pt+.pos());
	units[i].KillCommand();
}