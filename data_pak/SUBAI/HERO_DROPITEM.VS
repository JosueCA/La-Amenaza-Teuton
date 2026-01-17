// void, Obj me, Item item, point pt
Hero this;

this = me.AsHero ();

.FormSetupAndMoveTo (pt, 0, 0, true);
while (.HasPath ())
{
	.FormKeepMoving (1500);
}
.DropItem(item, pt); // Ako stane - stane :)

