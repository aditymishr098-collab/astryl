"""Terms and Conditions, and "Your data" (a plain summary of what is stored and how to control it).

These are written in plain words for an open-source hobby project. They are not legal advice.
"""

UPDATED = '17 November 2026'


def _sec(n, title, html):
    return f'<h2 id="s{n}">{n}. {title}</h2>{html}'


def terms_body():
    secs = [
        ('About these terms', '<p>Astryl (astryl.space) is a free, open-source website about space, made by Adity Mishra. By using the website you agree to these terms. If you do not agree, please do not use it. You can read everything without an account.</p>'),
        ('What Astryl is for', '<p>Astryl is for learning and for fun. We work hard to keep the numbers, dates and positions right, and we name our sources, but mistakes can happen. Do not use Astryl for navigation, for safety decisions, for school or professional work that needs a guaranteed source, or as the only source for anything important. Never look at the Sun without a proper solar filter, whatever a page or a photo here shows.</p>'),
        ('Your account', '<ul><li>An account is optional. It needs only a username and a password; we do not ask for your email address or your real name.</li><li>Choose a username that is not rude, does not pretend to be someone else or the Astryl team, and does not contain personal details.</li><li>Keep your password and your recovery code safe. Without them we cannot give the account back to you, because we have no email address to check who you are.</li><li>You can change your username once every 30 days and delete your account at any time on the <a href="account.html">Account page</a>.</li><li>If you are under 16, please ask a parent or guardian before making an account.</li></ul>'),
        ('Community and comments', '<p>In the <a href="community.html">Astryl Community</a> and in the comments on the <a href="blog.html">blog</a>, you agree to:</p><ul><li>be kind: no insults, hate, threats or bullying;</li><li>share only photos you took yourself, and only of the sky;</li><li>stay on the subject of space and the night sky;</li><li>not post links, advertising, spam, or anything illegal or sexual;</li><li>not share personal details, yours or anyone else’s (phone numbers, addresses, emails);</li><li>not try to break, overload or misuse the website, its quizzes or its leaderboards.</li></ul><p>Anyone can report a photo, post or comment. Reported items are checked by a moderator and may be hidden or removed. We may remove any content, and close accounts that break these rules, without warning.</p>'),
        ('What you share stays yours', '<p>Your photos and words remain yours. By posting them you allow Astryl to show them on the website, with your username or the name you typed, for as long as you leave them there. You can delete your own photos, posts and comments at any time, and they are removed when you delete your account (guest blog comments can be deleted from the same browser that posted them, or on request).</p>'),
        ('Astryl’s content and code', '<p>The source code of Astryl is public on GitHub and may be used under the licence in that repository. The photos on Astryl come from NASA, ESA, ISRO and other sources named under each photo; they keep their own licences and credits. The name “Astryl” and its logo belong to the project: please do not use them in a way that suggests your project is Astryl.</p>'),
        ('Quizzes, points and leaderboards', '<p>Space Points, streaks, badges and leaderboard places are for fun only. They have no money value and cannot be exchanged for anything. Scores gained by cheating or by automated tools may be removed.</p>'),
        ('Links and outside services', '<p>Some pages link to or load data from other services (for example NASA for the photo of the day). We are not responsible for what those services show or for their availability.</p>'),
        ('No guarantee', '<p>Astryl is offered free of charge and “as it is”. We do not promise that it will always be available, free of errors, or right for a particular purpose. As far as the law allows, the maker of Astryl is not liable for loss or damage that comes from using the website or relying on what it says.</p>'),
        ('Your privacy', '<p>What we store and why is explained in the <a href="privacy.html">Privacy Policy</a>, and in short form on the <a href="your-data.html">Your data</a> page.</p>'),
        ('Changes and contact', '<p>We may change these terms when the website changes. The new version is published on this page with a new date; if you keep using Astryl after that, the new terms apply. Questions: <a href="mailto:contact@astryl.space">contact@astryl.space</a>.</p>'),
    ]
    toc = ''.join(f'<a href="#s{i}">{i}. {t}</a>' for i, (t, _) in enumerate(secs, 1))
    return (f'<section class="blk policy-head"><h1>Terms and Conditions</h1><p class="note">Last updated {UPDATED} · applies to astryl.space</p>'
            '<p class="sub">In short: Astryl is free and made for learning. Be kind in the community, share only your own sky photos, and do not rely on Astryl for anything where a mistake could hurt someone.</p></section>'
            f'<section class="blk policy-layout"><nav class="toc" aria-label="Sections">{toc}</nav><div class="policy prose">'
            + ''.join(_sec(i, t, h) for i, (t, h) in enumerate(secs, 1)) + '</div></section>')


def data_body():
    def row(a, b, c, d):
        return f'<tr><td><b>{a}</b></td><td>{b}</td><td>{c}</td><td>{d}</td></tr>'
    rows = ''.join([
        row('Username and password', 'Your username; your password only as a scrambled hash that nobody can read, not even us', 'To log you in', 'Until you delete the account'),
        row('Recovery code', 'Only a scrambled hash of the code', 'So you can set a new password', 'Until you make a new code or delete the account'),
        row('Your settings', 'The switches you chose (shown on the leaderboard or not, and so on)', 'To do what you asked', 'Until you change them or delete the account'),
        row('My space and sync', 'Your favourites, quiz scores and streak', 'To keep them on every device', 'Until you delete the account'),
        row('Quiz and Daily 5', 'Rounds you played, your answers and score, your Space Points', 'For points, badges and leaderboards', 'Until you delete the account'),
        row('Community', 'Sky photos you upload (camera and location data are removed in your browser first), titles, questions, answers and stars', 'To show them to everyone', 'Until you delete them or the account'),
        row('Blog comments', 'The name you typed (or “Guest”), your comment, and scrambled ids used only to limit spam', 'To show the comment and stop spam', 'Until you delete it, or it is removed'),
        row('Reports', 'Which item was reported and why, with a scrambled id of the reporter', 'So a moderator can check it', 'Until the moderator decides'),
        row('Visit counts', 'A count per page, day and country. No name, no account, no internet address', 'To see which pages are useful', 'As totals only'),
    ])
    return (f'<section class="blk policy-head"><h1>🗂️ Your data</h1><p class="note">Last updated {UPDATED} · a plain summary of the <a href="privacy.html">Privacy Policy</a></p>'
            '<p class="sub">Astryl has no ads and sells nothing about you. Without an account almost nothing is stored about you at all. This page shows what is kept when you do use an account or post something, and how to see, change or delete it.</p></section>'
            '<section class="blk prose"><div class="stats"><div class="stat"><b>No</b><span>Ads or trackers</span></div><div class="stat"><b>No</b><span>Email address or real name needed</span></div><div class="stat"><b>No</b><span>Selling or sharing of your data</span></div><div class="stat"><b>1 tap</b><span>To delete your account and everything with it</span></div></div>'
            '<h2>What is stored</h2><div class="tscroll"><table class="cmp"><tr><th>What</th><th>Exactly what is kept</th><th>Why</th><th>How long</th></tr>' + rows + '</table></div>'
            '<h2>What stays only on your device</h2><p>Your theme (light or dark), your city for sky times, things you saved before making an account, your “days in a row” count on the home page and a random id used for comments and reports are kept in your browser only. Clearing your browser’s site data removes them.</p>'
            '<h2>What is never stored</h2><ul><li>Your password in readable form.</li><li>Your internet (IP) address. For rate limits we keep only a scrambled form that changes every day.</li><li>Your exact location. Sky times are worked out in your browser.</li><li>The camera and location details inside photos you upload.</li></ul>'
            '<h2>What you can do</h2><div class="grid" style="grid-template-columns:repeat(auto-fit,minmax(240px,1fr))">'
            '<div class="card"><h3>👀 See it</h3><p>Your <a href="account.html">Account page</a> and your public <a href="profile.html">profile</a> show what is tied to your account. <a href="my-space.html">My space</a> shows your saved things.</p></div>'
            '<div class="card"><h3>✏️ Change it</h3><p>Change your username, your leaderboard switch and your password on the Account page. Edit your own photos and posts from the ⋯ menu in the community.</p></div>'
            '<div class="card"><h3>🗑️ Delete it</h3><p>Delete single photos, posts and comments yourself. “Delete my account” on the Account page removes the account and everything stored with it, straight away.</p></div>'
            '<div class="card"><h3>📬 Ask for a copy</h3><p>Write to <a href="mailto:contact@astryl.space">contact@astryl.space</a> with your username to get a copy of your data or to have something corrected.</p></div></div>'
            '<h2>Where it is kept</h2><p>Astryl’s data is kept in a Supabase database that only Astryl’s own server code can read; the website itself is served by GitHub Pages. The details, including the old Android app, are in the <a href="privacy.html">Privacy Policy</a>. The rules for using Astryl are in the <a href="terms.html">Terms and Conditions</a>.</p></section>')


def build(h):
    shell, write = h['shell'], h['write']
    write('terms.html', shell('Terms and Conditions', 'Terms and Conditions', 'get', terms_body(), 'Astryl Terms and Conditions: the rules for using the website, the community and comments, accounts, content and limits of liability.', canonical='terms.html'))
    write('your-data.html', shell('Your data', 'Your data', 'get', data_body(), 'What Astryl stores about you, why and for how long, and how to see, change or delete it.', canonical='your-data.html'))
    return ['terms.html', 'your-data.html']
