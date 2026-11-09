"""Writes supabase/functions/account/quiz_bank.json: for every quiz kind the
right answer and the bodies the wrong answers are taken from. The Daily 5
function uses it to build and to check questions. The same answers are worked
out in lib/core/quiz.dart; test/quiz_bank_test.dart checks the two agree.
Run: python3 tools/gen_quiz_bank.py"""
import importlib.util, json, pathlib

root = pathlib.Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location('bs', root / 'tools/build_site.py')
bs = importlib.util.module_from_spec(spec); spec.loader.exec_module(bs)
B = bs.BODIES
by = {b['id']: b for b in B}
planets = [b for b in B if b['kind'] == 'planet']
rocky = [p for p in planets if p['order'] <= 4]
giants = [p for p in planets if p['order'] >= 5]
moons = [b for b in B if b['kind'] == 'moon']


def pick(lst, f, mx=True):
    best = lst[0]
    for b in lst[1:]:
        if (f(b) > f(best)) if mx else (f(b) < f(best)):
            best = b
    return best


bar = lambda b: b['bar'] or 0
by_d = lambda lst: sorted(lst, key=lambda b: -b['diam'])
ANS = {
    'largest': lambda: pick(planets, lambda p: p['diam']),
    'smallest': lambda: pick(planets, lambda p: p['diam'], False),
    'hottest': lambda: pick(planets, lambda p: p['temp']),
    'coldest': lambda: pick(planets, lambda p: p['temp'], False),
    'mostMoons': lambda: pick(planets, lambda p: p['moons']),
    'breathable': lambda: by['earth'],
    'closest': lambda: pick(planets, lambda p: p['dist'], False),
    'farthest': lambda: pick(planets, lambda p: p['dist']),
    'star': lambda: by['sun'],
    'dwarf': lambda: by['pluto'],
    'moonVisited': lambda: by['moon'],
    'strongestGravity': lambda: pick(planets, lambda p: p['g']),
    'shortestDay': lambda: pick(planets, lambda p: p['day'], False),
    'longestDay': lambda: pick(planets, lambda p: p['day']),
    'largestMoon': lambda: pick(moons, lambda p: p['diam']),
    'smallestMoon': lambda: pick(moons, lambda p: p['diam'], False),
    'thickAirMoon': lambda: pick(moons, bar),
    'geyserMoon': lambda: by['enceladus'],
    'volcanicMoon': lambda: by['io'],
    'backwardsMoon': lambda: by['triton'],
    'biggestRocky': lambda: pick(rocky, lambda p: p['diam']),
    'coldestRocky': lambda: pick(rocky, lambda p: p['temp'], False),
    'highestPressure': lambda: pick([p for p in planets if p['hasSurface']], bar),
    'secondLargest': lambda: by_d(planets)[1],
    'longestYear': lambda: pick(planets, lambda p: p['year']),
    'shortestYear': lambda: pick(planets, lambda p: p['year'], False),
    'smallestGiant': lambda: pick(giants, lambda p: p['diam'], False),
    'rockyLongestYear': lambda: pick(rocky, lambda p: p['year']),
    'fastestMoon': lambda: pick(moons, lambda p: p['year'], False),
    'slowestMoon': lambda: pick(moons, lambda p: p['year']),
    'strongestMoonGravity': lambda: pick(moons, lambda p: p['g']),
    'coldestMoon': lambda: pick(moons, lambda p: p['temp'], False),
    'secondLargestMoon': lambda: by_d(moons)[1],
}
ROCKY_Q = {'biggestRocky', 'coldestRocky', 'rockyLongestYear'}
MOON_Q = {'largestMoon', 'smallestMoon', 'thickAirMoon', 'volcanicMoon', 'backwardsMoon', 'moonVisited',
          'fastestMoon', 'slowestMoon', 'strongestMoonGravity', 'coldestMoon', 'secondLargestMoon'}


def pool(k):
    if k in ROCKY_Q: return rocky
    if k == 'smallestGiant': return giants
    if k in MOON_Q: return moons
    if k == 'geyserMoon': return [m for m in moons if m['id'] != 'europa']
    return planets


bank = {}
for k, f in ANS.items():
    a = f()['id']
    bank[k] = {'a': a, 'pool': [b['id'] for b in pool(k) if b['id'] != a]}
out = root / 'supabase/functions/account/quiz_bank.json'
out.write_text(json.dumps(bank, separators=(',', ':')) + '\n')
print(len(bank), 'questions ->', out)
