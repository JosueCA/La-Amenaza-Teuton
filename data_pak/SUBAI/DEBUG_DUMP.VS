// void
ObjList sel;
int i;

sel = GetSelection();
i = sel.Count();
while (i) {
  i -= 1;
  pr("Pos (" + /*sel[i].pos.x +*/ ", " + /*sel[i].pos.y +*/ "), Class " + sel[i].class + ", Script " + sel[i].script);
}
