// void, Obj This

Settlement this;
Wagon wagon;
point ptGo;

this = This.AsBuilding().settlement;

wagon = .CreateMuleFood(1000);
if(wagon.IsValid)
{
	ClearSelection(wagon.player);
	wagon.Select(wagon.player);

	ptGo.Set(This.radius,This.radius);
	wagon.AddCommand(false,"move",This.pos + ptGo);
	wagon.KillCommand();
}
