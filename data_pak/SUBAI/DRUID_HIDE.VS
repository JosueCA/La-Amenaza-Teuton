// void, Obj This, point pt

Druid this;
Sacrifice s;


this = This.AsDruid();
if (!.IsValid() || .health<=.maxhealth/10) return;

while (!.Goto(pt, 350, 2000, false, -1))
	if (.TimeWithoutWalking()>0)
		break;


.PlayAnim(18, pt);
s = Place("Hide", pt, .player).AsSacrifice();

if (!s.IsValid()) return;

.AddCommand(true, "help-sacrifice", s);

