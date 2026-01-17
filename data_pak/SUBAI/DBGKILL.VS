// void
ObjList o;
int i;

o = _GetSelection();
i = o.count();
while (i)
  {
    i-=1;
    o[i].Damage(o[i].health);
  }