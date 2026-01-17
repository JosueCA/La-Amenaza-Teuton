// void
int n;
n = 0;

//pr("SPF: Finding areas...");

while( SPFFindAreas_Quant() ) { 
  Sleep(30);
  n = n+30;
}

//pr("SPF: Initializing...");
SPFInitData();
Sleep(250);
n = n+250;

//pr("SPF: Initializing direction data...");
SPFInitDirectionData();
Sleep(400);
n = n+400;

//pr("SPF: Initializing PTA data...");
SPFInitPointToAreaData();
Sleep(250);
n = n+250;

//pr("SPF: Initializing connectivity data...");
SPFInitConnectData();
Sleep(250);
n = n+250;

while( SPFCalcConnectHighRes_Quant() ) {
	Sleep(23);
	n = n+23;
}

//pr("SPF: Increasing connectivity...");
SPFIncreaseConnect();
Sleep(250);
n = n+250;

while( SPFIncreaseConnect_Quant() ) {
    Sleep(35);
	n = n+35;
}

SPFDone();
//pr("New pathfinder structures built.");
//pr("Total time: " + n);
