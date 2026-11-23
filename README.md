# Ebb
Ebb je 2D igra iz ptičje perspektive, kjer se igralec pomika skozi proceduralni teren,
medtem pa konstanto izgublja življenje. Življenje pridobi (ali izgubi) s pomočjo hrane in tako
imenovanih pickupov, na voljo ima tudi razne power-upe, ki ga naredijo močnejšega in mu
podarijo različne predmete (hitrost, počasnejše izčrpavanje življenja, obleke ...). Na terenu so
tudi sovražniki, ki igralca napadajo. Igralec lahko pred sovražniki beži ali pa se jim izogne z
dodge-rollom. V igri so tudi prisotni različni tipi terena (zimski, poletni itd.).

## Licenca

- **Koda: GPL-3.0-or-later** — glej [`LICENSE`](LICENSE). Kdorkoli distribuira to igro
  ali njeno predelavo, mora pod isto licenco ponuditi ustrezno izvorno kodo; ta javni
  repozitorij že služi kot takšna ponudba.
- **Sredstva (grafika, glasba, zvočni učinki): CC BY-SA 4.0** — GPL pokriva samo kodo,
  zato so ustvarjalna sredstva licencirana ločeno (Creative Commons
  Attribution-ShareAlike 4.0: atribucija obvezna, izpeljana dela pod isto licenco).
- **Pogon:** Godot Engine je licenciran MIT in je združljiv z GPL; obvestilo o
  avtorskih pravicah je v [`CREDITS.md`](CREDITS.md).

> GPL proti AGPL: GPL velja, ko nekdo **distribuira** igro (jo proda, deli build ...);
> AGPL pa dodatno še, ko nekdo igro poganja na strežniku in z njo prek omrežja
> komunicirajo drugi uporabniki. Ebb se igra lokalno, zato je GPL-3.0 prava izbira.
> Če boš kdaj dodal omrežno strežniško komponento, preklopi na AGPL-3.0-or-later
> (zamenjaj besedilo v `LICENSE` in posodobi ta razdelek).

### Neobvezna glava izvorne datoteke

```gd
# <ime datoteke> — del igre Ebb
# Copyright (C) 2026 Ebb contributors
#
# Licencirano pod GNU GPL v3.0 ali poznejšo različico.
# Glej LICENSE: https://www.gnu.org/licenses/gpl-3.0.html
```
