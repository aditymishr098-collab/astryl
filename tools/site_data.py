"""Where the website's own data lives (the data/ folder), so the site does not depend on the app.

data/text/     English and Hindi texts (app_en.arb, app_hi.arb)
data/tables/   planets, moons, stars, constellations, cities, missions, events, facts, the
               world map and the universe catalogue, kept in the original Dart table format
               that the build scripts read
data/cities/   the world city list (GeoNames, CC BY 4.0), made by tools/build_cities.py
data/fonts/    the fonts used on the site and for the share pictures
"""
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / 'data'
TEXT = DATA / 'text'
TABLES = DATA / 'tables'
CITIES = DATA / 'cities'
FONTS = DATA / 'fonts'


def table(name):
    """The text of one data table, e.g. table('planets.dart')."""
    return (TABLES / name).read_text(encoding='utf-8')
