// void, Obj This

Settlement this;
int min_resource;
Wagon wagon;

this = This.AsBuilding().settlement;
min_resource = GetConst("MinResQtyToTransport");

while (1) {
	Sleep(3000);
	if (.supplied == this)
		.StopSupply();
	if (!.supplied.IsValid()) continue;

	if (.gold > min_resource) {

		if(.supplied.GetCentralBuilding.IsHeirOf("BaseShipyard") && .supplied.WaterLsa == .WaterLsa)
			wagon = .CreateBoatGold(1000);
		else
			wagon = .CreateMuleGold(1000);

		wagon.SetCommand("unload", .supplied.GetCentralBuilding());
	} else
	if (.food > min_resource) {

		if(.supplied.GetCentralBuilding.IsHeirOf("BaseShipyard") && .supplied.WaterLsa == .WaterLsa)
			wagon = .CreateBoatFood(1000);
		else
			wagon = .CreateMuleFood(1000);

		wagon.SetCommand("unload", .supplied.GetCentralBuilding());
	}
}