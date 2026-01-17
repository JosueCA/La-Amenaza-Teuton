// void, Obj This


Building this;
int nFeedingInterval, i;
ObjList ol;

this = This.AsBuilding();
nFeedingInterval = GetConst("DropFoodByOneIvl");

while (1) {
	//feed the teutons inside
	ol = .settlement.Units();

	for (i=0; i<ol.count; i+=1) {
		ol[i].AsUnit().SetFood(10);
	}
	Sleep(nFeedingInterval*2);
}
