// void
ObjList sel;
int i;

ClearDebug();
sel = _GetSelection();
i = sel.count();
while (i) {
  i -= 1;
  sel[i].SetDebug(true);
}
cls();