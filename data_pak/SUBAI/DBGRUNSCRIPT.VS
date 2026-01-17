// void
str choice;
choice = Choose("Run", ListFolderEx("data/subai", ".vs"));
if (StrLen(choice))
  Run("data/subai/" + choice);
