// void, Obj This

Druid this;
Sacrifice s;

this = This.AsDruid();
if (!.IsValid() || .health<=.maxhealth/10) return;

.PlayAnim(18, .pos);
s = Place("Possess", .posRH, .player).AsSacrifice();

if (!s.IsValid()) return;
.AddCommand(true, "help-sacrifice", s);

