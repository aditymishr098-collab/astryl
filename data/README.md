# Website data

Everything the website build (`tools/build_site.py`) reads lives here, so the
site does not depend on the app's code.

| Folder | What | Source and licence |
|---|---|---|
| `text/` | English and Hindi texts (`app_en.arb`, `app_hi.arb`) | Astryl, AGPL-3.0 |
| `tables/` | Planets, moons, stars and constellations, cities, missions, events, facts, the world map and the universe catalogue, in the original Dart table format the build scripts read | Astryl, AGPL-3.0; galaxies from OpenNGC (CC BY-SA 4.0) |
| `cities/` | World city list, made by `tools/build_cities.py` | GeoNames (CC BY 4.0) |
| `fonts/` | DM Sans and Space Grotesk | SIL Open Font License (see the OFL files) |

Translations into Spanish, Portuguese, French and Arabic are in `tools/i18n/`.
