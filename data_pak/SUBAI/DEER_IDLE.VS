// void, Obj me

Unit this;
point pt, ptCenter;
ObjList ol;
int i, checkIterations;
this = me.AsUnit;
//pr("Deer");
pt = .GetDir;
pt.SetLen(15 + rand(50));
pt.Rot(rand(60));
checkIterations = 0;
while(!IsPassable3x3(pt))
{
	pt.SetLen(15 + rand(50));
	pt.Rot(rand(60));
	pt = .pos + pt;
	Sleep(1000);
	checkIterations += 1;
	if(checkIterations > 10) break; // Prevent infinite loop
}
.Face(pt);
.SetSpeedFactor(7);
.SetWalkAnim(13);
ol = ObjsInSight(this, "Wolf,Building,Unit").GetObjList;
if(ol.count > 0)
{
	ptCenter = ol[0].pos;
	for(i = 1; i < ol.count; i += 1)
	{
		ptCenter = ptCenter + ol[i].pos;
	}
	ptCenter = ptCenter / ol.count;
	ptCenter = .pos - ptCenter;
	ptCenter.Rot(rand(30)-15);
	ptCenter.SetLen(.sight*2);
	ptCenter = .pos + ptCenter;
	.SetWalkAnim(1);
	.SetSpeedFactor(170);
	.AddCommand(true, "unitmove", .ClipDestToMap(ptCenter));
	return;
}
checkIterations = 0;
while(!.Goto(pt, 0, 2000, true, 0))
{
	Sleep(100);
	checkIterations += 1;
	// Only check for threats every 5 iterations to reduce memory allocation
	if(checkIterations % 5 == 0)
	{
		ol = ObjsInSight(this, "Wolf,Building,Unit").GetObjList;
		if(ol.count > 0)
		{
			ptCenter = ol[0].pos;
			for(i = 1; i < ol.count; i += 1)
			{
				ptCenter = ptCenter + ol[i].pos;
			}
			ptCenter = ptCenter / ol.count;
			ptCenter = .pos - ptCenter;
			ptCenter.Rot(rand(30)-15);
			ptCenter.SetLen(.sight*2);
			ptCenter = .pos + ptCenter;
			.SetWalkAnim(1);
			.SetSpeedFactor(170);
			.AddCommand(true, "unitmove", .ClipDestToMap(ptCenter));
			return;
		}
	}
	if(checkIterations > 30) break; // Timeout after 30 iterations
};
.Heal(.maxhealth/6);
.SetSpeedFactor(150);
.SetWalkAnim(1);


pt = .GetDir;
pt.SetLen(rand(150)+ 225);
pt = .pos + pt;

checkIterations = 0;
while(!IsPassable3x3(pt))
{
	pt.SetLen(rand(150)+ 225);
	pt.Rot(rand(60));
	Sleep(1000);
	pt = .pos + pt;
	checkIterations += 1;
	if(checkIterations > 10) break; // Prevent infinite loop
}

ol = ObjsInSight(this, "Wolf,Building,Unit").GetObjList;
if(ol.count > 0)
{
	ptCenter = ol[0].pos;
	for(i = 1; i < ol.count; i += 1)
	{
		ptCenter = ptCenter + ol[i].pos;
	}
	ptCenter = ptCenter / ol.count;
	ptCenter = .pos - ptCenter;
	ptCenter.Rot(rand(30)-15);
	ptCenter.SetLen(.sight*2);
	ptCenter = .pos + ptCenter;
	.SetWalkAnim(1);
	.SetSpeedFactor(170);
	.AddCommand(true, "unitmove", .ClipDestToMap(ptCenter));
	return;
}
checkIterations = 0;
while(!.Goto(pt, 0, 2000, true, 0))
{
	Sleep(100);
	checkIterations += 1;
	// Only check for threats every 5 iterations to reduce memory allocation
	if(checkIterations % 5 == 0)
	{
		ol = ObjsInSight(this, "Wolf,Building,Unit").GetObjList;
		if(ol.count > 0)
		{
			ptCenter = ol[0].pos;
			for(i = 1; i < ol.count; i += 1)
			{
				ptCenter = ptCenter + ol[i].pos;
			}
			ptCenter = ptCenter / ol.count;
			ptCenter = .pos - ptCenter;
			ptCenter.Rot(rand(30)-15);
			ptCenter.SetLen(.sight*2);
			ptCenter = .pos + ptCenter;
			.SetWalkAnim(1);
			.SetSpeedFactor(170);
			.AddCommand(true, "unitmove", .ClipDestToMap(ptCenter));
			return;
		}
	}
	if(checkIterations > 30) break; // Timeout after 30 iterations
}