// void, Obj me, Item item, Obj h

Unit this, other;

this = me.AsUnit();
other = h.AsUnit();

//.pr("chasing unit to give him something");

while(!.Goto(other, GetConst("GiveDistance"), 1500, true, 5000));
if(!.IsVisible)
	.SetVisible(true);
.GiveItem(item, other); // Ako stane - stane :)