//bool, ObjList objs, str OUT reasonText

int nMinRes;

nMinRes = GetConst("MinResQtyToTransport");
if(objs.count)
{
	Building bld;
	bld = objs[0].AsBuilding();
	if(bld.IsValid)
	{
		Settlement this;
		this = bld.settlement;
		if(.IsValid)
		{
			if(.gold < nMinRes)
			{
				reasonText = Translatef("%s1 (requires %s2 gold)", rollover, nMinRes);
				return false;
			}
		}
	}
}
return true;