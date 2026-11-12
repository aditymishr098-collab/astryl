# Website data

Everything the website build (`tools/build_site.py`) reads lives here, so the
site does not depend on the app's code.

| Folder | What | Source and licence |
|---|---|---|
| `text/` | English and Hindi texts (`app_en.arb`, `app_hi.arb`) | Astryl, AGPL-3.0 |
| `tables/` | Planets, moons, stars and constellations, cities, missions, events, facts, the world map and the universe catalogue, in the original Dart table format the build scripts read | Astryl, AGPL-3.0; galaxies from OpenNGC (CC BY-SA 4.0) |
| `cities/` | World city list, made by `tools/build_cities.py` | GeoNames (CC BY 4.0) |
| `photos/` | Planet and moon photos (WebP, made smaller), with `credits.json` | NASA and partners, public domain; fetched from Wikimedia Commons by `tools/media/fetch_media.py` |
| `photos/space/` | Black holes, galaxies, nebulae, the Sun and eclipses (WebP), with `credits.json` and `report.json` | Public domain, CC BY or CC BY-SA, credit on every picture; fetched from Wikimedia Commons by `tools/media/fetch_space.py`; spacecraft, the pictures they took, landing sites, the space station and the Mars map by `tools/media/fetch_missions.py` (also India's GODL licence); big Moon and Earth maps from Solar System Scope (CC BY 4.0) |
| `textures/` | Surface maps used to draw the turning globes | Solar System Scope (CC BY 4.0), made from NASA mission data |
| `icons/` | Icons for the installable website | Astryl |
| `fonts/` | DM Sans and Space Grotesk | SIL Open Font License (see the OFL files) |

Translations into Spanish, Portuguese, French and Arabic are in `tools/i18n/`.
