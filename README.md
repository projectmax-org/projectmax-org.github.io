# projectmax.app

The Project Max website: a landing page for the project and one page per app. Plain HTML and CSS,
no build step, no external requests. Served by GitHub Pages from this repository.

```
index.html            Project Max
driftwall/index.html  Driftwall
assets/               stylesheet, icons, screenshots
CNAME                 the custom domain GitHub Pages serves this on
```

## Publishing

1. Push to `main`. The workflow in `.github/workflows/pages.yml` deploys the repository as is.
2. In the repository settings, under **Pages**, set the source to **GitHub Actions** and the custom
   domain to the name in `CNAME`. Tick **Enforce HTTPS** once the certificate is issued.
3. At the domain registrar, point the apex at GitHub Pages and `www` at the organisation's Pages host:

   | Record | Name | Value |
   |---|---|---|
   | A | @ | 185.199.108.153 |
   | A | @ | 185.199.109.153 |
   | A | A | 185.199.110.153 |
   | A | @ | 185.199.111.153 |
   | AAAA | @ | 2606:50c0:8000::153, 2606:50c0:8001::153, 2606:50c0:8002::153, 2606:50c0:8003::153 |
   | CNAME | www | `projectmax-org.github.io` |

4. **driftwall.org** is a redirect, not a second site. At its registrar, forward the whole domain
   (apex and `www`, permanent 301, HTTPS) to `https://projectmax.app/driftwall`. Most registrars
   offer this under "forwarding" or "redirect"; nothing needs to be deployed for it.

## Editing

Screenshots in `assets/screens` are 1180×760 window captures from the app; replace them when the UI
changes. The icon is `logo-512.png` from the Driftwall repository. Keep pages self-contained: one
stylesheet, inline SVG icons, no scripts.
