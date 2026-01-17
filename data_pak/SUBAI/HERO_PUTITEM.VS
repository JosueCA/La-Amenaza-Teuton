// void, Obj me, Item item, Obj h

Hero        this;
ItemHolder  holder;
point      pt;

this = me.AsHero ();
holder = h.AsItemHolder ();

if (.PathTo (holder, .FormRadius (), 0) > .FormRadius ())
{
	.FormSetupAndMoveTo (holder, GetConst("GiveDistance"), 0, true);
	while (.HasPath ())
	{
		.FormKeepMoving (1500);
	}
	pt = .pos;
}
else
	pt.Set (-1, -1);
.army.SetCommand("idle");
while(!.Goto (holder, GetConst("GiveDistance"), 1500, false, 5000));
.PutItem (item, holder);
if (pt.x != -1)
  while (!.Goto (pt, 0, 1500, false, 5000));