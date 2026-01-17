// void, Obj me, Item item, Obj h

Hero    this;
Unit    unit;
point  pt;
bool    bRunAway;
int	nDist;

this = me.AsHero;
unit = h.AsUnit;

nDist = .PathTo(unit, .FormRadius, 0);
if (nDist == -1)
	return;

if (nDist > .sight)
{
  .FormSetupAndMoveTo (unit, 0, 0,true);
	while (.HasPath)
    .FormKeepMoving (1500);
  }
else
.army.SetCommand("idle");

pt = .posRH;
while ( ! .Goto (unit, GetConst("GiveDistance"), 1500, false, 5000))
{
	if (.PathTo(pt, 0, 0) > .FormRadius + 50)
  {
		pt.Set(.posRH.x + 1, .posRH.y + 1);
    .FormSetupAndMoveTo (pt, 0, 0, true);
		while (.HasPath)
      .FormKeepMoving (1500);
		if (.PathTo(unit, .FormRadius, 0) > 50)
    {
      .FormSetupAndMoveTo (unit, 0, 0, true);
			while (.HasPath)
        .FormKeepMoving (1000);
			pt = .posRH;
      }
    }
	if (!unit.IsAlive)
		return;
	if (unit.InHolder)
		return;
}
.GiveItem (item, unit);

if (.HasArmy) 
	while (!.Goto(pt, 0, 1500, false, 5000));
