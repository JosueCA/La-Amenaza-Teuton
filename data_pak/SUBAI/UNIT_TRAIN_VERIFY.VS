//bool, ObjList objs, str OUT reasonText
int i, level;
ObjList army;

if (objs.count == 0) return false;
level = EnvReadInt(objs[0].player, "maxtrainlevel");
for(i = 0; i < objs.count(); i += 1)
{
	if(objs[i].AsUnit().inherentlevel < level)
		return true;
	if(objs[i].AsHero().IsValid)
	{
		int j;
		army = objs[i].AsHero().army;
		for(j = 0; j < army.count(); j += 1)
		{
			if(army[j].AsUnit().inherentlevel < level)
				return true;
		}
	}
}
reasonText = Translate("Cannot train units");
return false;