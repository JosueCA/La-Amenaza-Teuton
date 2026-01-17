// void, Obj This

Settlement this;
Ship       ship;
point      pt;

this = This.AsBuilding.settlement;
.GetCentralBuilding.Progress();
ship = .CreateShip();

pt = .GetCentralBuilding.GetExitVector();

ship.ShowBuildAnimation( pt );