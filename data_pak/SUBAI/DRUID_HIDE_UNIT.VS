// void, Obj This, Obj target


Druid this;
Sacrifice s;
Unit tgt;
bool bThere;

this = This.AsDruid();
if (!.IsValid() || !target.IsValid()) return;
tgt = target.AsUnit();
if (!tgt.IsValid()) return;

bThere = .DistTo(target) <= 300;

while (target.IsAlive() && !.IsEnemy(target) && target.IsVisible() && target != this && !bThere)
{
	bThere = .Goto(target, 300, 2000, false, 2500);
}
if (!(target.IsAlive() && !.IsEnemy(target) && target.IsVisible())) return;

.PlayAnim(18, target.pos);
s = Place("Hide", target.pos, .player).AsSacrifice();

if (!s.IsValid()) return;

.AddCommand(true, "help-sacrifice", s);


