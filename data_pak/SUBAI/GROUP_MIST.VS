//void, ObjList objs,point pt, Obj obj, bool bReplace, bool bModifier, int player

Druid d, creator;

creator.Clear;
objs.ClearDead();
while(objs.count()) {
	d = objs[0].AsDruid();
	if (d.IsValid) {
    d.ClearCommands();
	  if (!creator.IsValid) {
      d.AddCommand(true, "mist", pt);
      creator = d;
		} else
      d.AddCommand(true, "help-sacrifice", creator);
    d.KillCommand();
	}
  objs.Remove(objs[0]);
}
