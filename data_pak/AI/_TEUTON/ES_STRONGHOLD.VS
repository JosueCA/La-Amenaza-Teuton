// void, Settlement set
// Script de economia para fortalezas conquistadas por Teutones
// Genera oro y comida para mantener el ejercito

int AIPlayer;
int nFoodBonus;
int nGoldBonus;
int i;

AIPlayer = set.player;

while (set.player == AIPlayer) {
  // Aplicar bonus de dificultad si existe
  i = AIVar(AIPlayer, AIV_FoodBonus);
  if (i > 0) set.SetFood(set.food + i);

  i = AIVar(AIPlayer, AIV_GoldBonus);
  if (i > 0) set.SetGold(set.gold + i);

  Sleep(AIVar(AIPlayer, AIV_Sleep_ES));
}
