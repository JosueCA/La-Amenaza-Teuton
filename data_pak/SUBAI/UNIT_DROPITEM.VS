// void, Obj me, Item item, point pt

Unit this;
ItemHolder holder;

this = me.AsUnit();


while(!.Goto(pt, GetConst("GiveDistance"), 1500, true, 5000));
.DropItem(item, pt); // Ako stane - stane :)
