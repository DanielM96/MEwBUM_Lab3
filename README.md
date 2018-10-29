# MEwBUM_Lab3
Metody eksperymentalne w badaniach układów mechatronicznych - Matlab GUI - Lab3

Laboratorium nr 3 - Analiza danych z samochodu aka Passat

# Zawartość

___csv2mat.m___

Funkcja do konwersji plików CSV do plików MAT. Program wszystkie dane wczytuje z plików, dlatego ważne jest, by wczytywały się jak najszybciej. Szybkość wczytywania plików MAT jest znacznie wyższa niż plików CSV (ma to znaczenie zwłaszcza w GUI_ComparisonContainer), a użycie tej funkcji pozwala zautomatyzować ich konwersję.

___GUI_AboutPassatContainer___

Informacje o badanym Passacie i o tym, co pokazuje obrotomierz.

___GUI_AdditionalContainer___

Moduł do wyświetlania wyników analizy modalnej i rozruchu zimnego silnika (do usunięcia rozruch zimnego silnika).

___GUI_ComparisonContainer___

Moduł do porównywania serii danych na wykresie typu kaskadowego.

___GUI_Passat___

Podstawowy moduł pozwalający wyświetlić przebieg czasowy, widmo i spektrogram dla wybranego pomiaru.

___importfile.m___

Funkcja importująca dane z plików CSV do przestrzeni roboczej. W porównaniu do wersji pierwotnej, wygenerowanej przez MATLAB (patrz niżej), nie zawiera niepotrzebnych operacji, a konieczne wykonuje w szybszy sposób. Pozwala to na ok. 5-krotne przyspieszenie wczytywania danych.

___importfile_slow.m___

Pierwotna wersja powyższej funkcji.
