// void, Obj me, Item item, Obj h

Unit this;

this = me.AsUnit();

//.pr("chasing unit to give him something");

while(!.Goto(h, GetConst("GiveDistance"), 1500, true, 5000));
if(!.IsVisible)
	.SetVisible(true);
h.GiveItem(item, this); // Ako stane - stane :)