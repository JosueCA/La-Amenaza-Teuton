// void, Obj This 
// cmdparam is like this ReqSet, <research>, ReqPlr, <research>, SetsPlr, <env>, <value>, SetsSet, <env>, <value>, NamePlr, <research>, NameSet, <research>

str dest, name, token;
int global;
Building this;
this = This.AsBuilding();
dest = cmdparam;

EnvWriteString(this, "researching", "yes");

while(dest != "")
{
	token = ParseStr(dest, dest);
	if(token == "NamePlr")
	{
		name = ParseStr(dest, dest);
		global = 1;
		break;
	}
	if(token == "NameSet")
	{
		name = ParseStr(dest, dest);
		global = 0;
		break;
	}
}

if(global == 0)
	EnvWriteString(.settlement, name, "researching");
else
	EnvWriteString(.player, name, "researching");

.Progress();
