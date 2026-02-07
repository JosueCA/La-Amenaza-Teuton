// void, Obj This, Obj other

Hero		this;
ItemHolder	holder;
point		pt;

this = This.AsHero ();
holder = other.AsItemHolder ();

if ( ! holder.IsValid ()) return;

if (.PathTo (holder, .FormRadius(), 0) > .sight)
{
  .FormSetupAndMoveTo (holder, GetConst("GiveDistance"), 0,true);
  while (.HasPath ())
  {
    .FormKeepMoving (1500);
  }
}
pt = .pos;
.army.SetCommand("idle");
while (!.Goto (holder, GetConst("GiveDistance"), 1500, false, 5000));
.OpenItemHolder (holder);
if (.AI) return;
if (.HasArmy ()) while (!.Goto (pt, 0, 1500, false, 5000));