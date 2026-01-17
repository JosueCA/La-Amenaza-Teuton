// void, Obj This

Settlement this;
Building   b1,b2,bDamaged;
bool       bWater, bGoods, bWalk, bPeasantFound, bHideStart, bIsCity;
str        strMaleVillager, strFemaleVillager;
point      pt1, pt2, pt;
Unit       u1, hen;
ObjList    ol, enemies;
ObjList    hens;
int        rnd, count, i, j, hideTime, chPopTime;
int        oldPop, newPop, oldPlayer, newPlayer;
Query      ProtectiveArea;
Query      Alert;
int			tries;

Sleep( rand( 800 ));

if(MapSize >= 32000)  // if huge map 
	return;
this = This.AsBuilding.settlement;
if( ! This.AsBuilding.IsValid )
{
//  pr( "settlement_behavior_ambient: Not valid building as parameter!" );
  return;
}
hideTime = 0;
bHideStart = false;
oldPop = .population;
oldPlayer = .player;
bIsCity = .IsCity;
chPopTime = 8000;

ProtectiveArea = ObjsInCircle( .GetCentralBuilding.pos, 900, "Unit" );
Alert = Intersect( ProtectiveArea, EnemyObjs( .player, "Unit" ));


if( .IsVillage )
{
	count = 4 + rand( 3 );
	for( i = 0; i < count; i += 1 )
	{
		for( j = 0; j < 5; j += 1 )
		{
			pt.Set( .GetCentralBuilding.pos.x + 600 - rand( 1200 ), .GetCentralBuilding.pos.y + 600 - rand( 1200 ));			
			if( IsPassable3x3( pt )) break;
		}
		if( j < 5 )
		{
			hen = Place( "Hen", pt, 15 );
			hen.SetFeeding( false );
			hen.SetNoselectFlag( true );
			hen.SetMinimapFlag( true );
			hens.Add( hen );
		}
	}
	count = 0;
}

if( .IsGaul )
{
	strMaleVillager   = "GVillagerAmbient";
	strFemaleVillager = "GWVillagerAmbient";
}
else
{
	strMaleVillager   = "RVillagerAmbient";
	strFemaleVillager = "RWVillagerAmbient";
}
while( 22 )
{
	newPop = .population;
	newPlayer = .player;

	if( chPopTime <= 0 )
	{
		count = .population / 10;
		if( count == 0 && .population > 0 ) count = 1;
		if( count > 4 ) count = 4;
		if( bIsCity && count > 3 ) count = 3;
		if( rand( 100 ) < 40 ) count = 2;
		if( rand( 100 ) > 90 ) count = 0;
		chPopTime = 8000;
	}
	ol.ClearDead();

// player changed
	if( newPlayer != oldPlayer )
	{
		Alert = Intersect( ProtectiveArea, EnemyObjs( .player, "Unit" ));
		for( i = 0; i < ol.count; i += 1 )
			ol[i].SetPlayer( newPlayer );
		oldPlayer = newPlayer;
		Sleep( 50 );
	}
// building damaged
	bDamaged = .MostDamagedBuilding;
	if( bDamaged.IsValid )
	{
		bDamaged.ClearDamageTaken;
		hideTime = 5000;
	}
// enemies around central building
	if( ! Alert.IsEmpty )
	{
		hideTime = 5000;
	}
// unit hurt
	for( i = 0; i < ol.count; i += 1 )
	{
		if( ol[i].health < ol[i].maxhealth * 3 / 4 )
		{
			hideTime = 5000;
			break;
		}
	}
// if villagers are disabled from environment ('no_villagers' = [0/1] )
	if( EnvReadInt( this, "no_villagers" ) == 1 )
	{
		if( hideTime < 20 ) hideTime = 20;

		if( hens.count > 0 )
		{
			for( i = 0; i < hens.count; i += 1 )
				hens[i].Erase();
			hens.ClearDead();
		}
	}

// 1. Danger - hide all villagers and wait a little
	if( hideTime > 0 )
	{
    // hide all villagers in the closest buildings
		if( ! bHideStart )
		{
			bHideStart = true;
			for( i = 0; i < ol.count; i += 1 )
				if( ol[i].command=="disappear" || ol[i].pos.x == -1 ) // Ivko: It crashed in this case. It is now patched
					ol[i].Erase();
				else
				{
					pt1 = .FindNearEnterExit( ol[i].pos );
					ol[i].SetCommand( "moveenter", pt1 );
					ol[i].AddCommand( false, "dismiss" );
				}
		}
	// if building is attacked and population decreases - play 'villager dies' animation
		for( newPop = .PopulationDied; oldPop < newPop; oldPop += 1 )
		{
			if( rand( 100 ) <= 40 )
			{
				if( bDamaged.IsValid )
					pt1 = bDamaged.GetEnterExit;
				else
					pt1.Set( -1, -1 );
				b1 = bDamaged;
				if( pt1.x == -1 )
				{
					b1 = .GetEnterExit;
					if( b1.IsValid ) pt1 = b1.GetEnterExit;
				}
				if( b1.IsValid && pt1.x != -1 )
				{
					pt2.Set( 2 * pt1.x - b1.pos.x + 50 - rand(100), 2 * pt1.y - b1.pos.y + 50 - rand(100));
					if( rand( 100 ) <= 50 )
						u1 = Place( strMaleVillager, pt1, .player );
					else
						u1 = Place( strFemaleVillager, pt1, .player );
					u1.SetFeeding( false );
					u1.SetNoselectFlag( true );
					u1.SetMinimapFlag( true );
					u1.SetCommand( "walkanddie", pt2 );
				}
			}
		}
	}
// 2. No danger conditions - work, talk and wander
	else
	{
		bHideStart = false;
		.ClearDamageTaken;
	// talk behavior
		for( i = 0; i < ol.count - 1; i += 1 )
		{
			if (ol[i].IsDead()) continue; //this happened once, dunno why
			if( ol[i].command == "moveenter" )
			{
				if( ol[i].AsUnit.DoCarryNothing )
				for( j = i + 1; j < ol.count; j += 1 )
				{
					if( ol[j].command == "moveenter" && ol[j].AsUnit.DoCarryNothing  )
					{
						if( rand(10) < 8 ) if ( Dist( ol[i].pos, ol[j].pos ) < 120 )
						{
							ol[i].SetCommand( "talk", ol[j] );
							ol[j].SetCommand( "talk", ol[i] );
							Sleep( 50 );
						}
					}
				}
			}
		}
	// find idle villagers and command them
		ol.ClearDead();
		for( i = 0; i < ol.count; i += 1 )
		{
			if( ol[i].command == "idle" ) break;
		}
		bPeasantFound = false;
		if( i < ol.count )
		{
			if( ol[i].pos.x == -1 )
				ol[i].Erase();
			else
			{
				u1 = ol[i];
				if( ! u1.DoCarryNothing )
				{
					b1 = .GetEnterExit;
					pt1 = b1.GetEnterExit;
					u1.SetCommand( "moveenter", b1.GetEnterExit );
					u1.AddCommand( false, "dismiss" );
				}
				else
					bPeasantFound = true;
			}
		}
		if( ol.count < count || bPeasantFound )
		{
			bWater = false;
			bGoods = false;
			bWalk  = false;
			rnd    = rand( 100 );

			b1 = .GetEnterExit;
			if( ! b1.IsValid )
			{
//				pr( "Unable to find any suitable building for ambient villagers behavior!" );
				break;
			}
	// decide what to do with the next villager
	// rnd: 0-15/water, 15-30/male goods, 30-45/female goods, 45-100/walk
			for(tries = 0; tries < 5; tries += 1)
			{
				b2 = .GetWaterSource;
				if(b1 != b2)
					break;
			}
			if( b2.IsValid && rnd < 15 )
			{
				bWater = true;
			}
			else
			{
				for(tries = 0; tries < 5; tries += 1)
				{
					b2 = .GetGoodsSource;
					if(b1 != b2)
						break;
				}
				if( b2.IsValid && ( rnd < 45 || count < 4 ))
				{
					bGoods = true;
				}
				else
				{
				for(tries = 0; tries < 5; tries += 1)
				{
					b2 = .GetEnterExit;
					if(b1 != b2)
						break;
				}
					if( ! b2.IsValid )
						break;
					else
						bWalk = true;
				}
			}
			pt1 = b1.GetEnterExit;
			if( pt1.x != -1 )
			{
				if( bWater )
				{
					if( ! bPeasantFound )
					{
						u1 = Place( strFemaleVillager, pt1, .player );
						u1.SetEntering( true );
						u1.SetFeeding( false );
						u1.SetMessengerStatus( true );
						u1.SetNoselectFlag( true );
						u1.SetMinimapFlag( true );
						ol.Add( u1 );
					}
					pt2 = b2.GetWaterSource;
					u1.SetCommand( "moveenter", pt2 );
					u1.AddCommand( false, "disappear" );
					u1.AddCommand( false, "grab_water" );
					u1.AddCommand( false, "moveenter", pt1 );
				}
				else
				if( bGoods )
				{
					if( ! bPeasantFound )
					{
						if( rnd >= 30 )
							u1 = Place( strMaleVillager, pt1, .player );
						else
							u1 = Place( strFemaleVillager, pt1, .player );
						u1.SetFeeding( false );
						ol.Add( u1 );
						u1.SetEntering( true );
						u1.SetMessengerStatus( true );
						u1.SetNoselectFlag( true );
						u1.SetMinimapFlag( true );
					}
					pt2 = b2.GetGoodsSource;

					u1.SetCommand( "moveenter", pt2 );
					u1.AddCommand( false, "disappear" );
					u1.AddCommand( false, "grab_goods" );
					u1.AddCommand( false, "moveenter", pt1 );
				}
				else
				if( bWalk )
				{
					pt2 = b2.GetEnterExit;
					if( ! bPeasantFound )
					{
						if( rand( 10 ) < 5 )
							u1 = Place( strMaleVillager, pt1, .player );
						else
							u1 = Place( strFemaleVillager, pt1, .player );
						u1.SetFeeding( false );
						u1.SetEntering( true );
						ol.Add( u1 );
						u1.SetMessengerStatus( true );
						u1.SetNoselectFlag( true );
						u1.SetMinimapFlag( true );
					}
					u1.SetCommand( "moveenter", pt2 );
				}
				u1.AddCommand( false, "dismiss" );
				u1.SetCmdEnable( false );
			}
		}
	}
	oldPop = newPop;
	Sleep( 2517 );
	hideTime -= 2517;
	chPopTime -= 2517;
	if( hideTime < 0 ) hideTime = 0;
}
Sleep( 1000 );