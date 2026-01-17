// void, Obj me, Item item, Obj h

Unit this;
ItemHolder holder;

this = me.AsUnit();
holder = h.AsItemHolder();

while(!.Goto(holder, GetConst("GiveDistance"), 1500, true, 5000));
if(!.IsVisible)
	.SetVisible(true);
.PutItem(item, holder); // Ako stane - stane :)
