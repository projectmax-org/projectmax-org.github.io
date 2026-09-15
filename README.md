# projectmax-org.github.io

The Project Max website: a landing page for the project and one page per app. Plain HTML and CSS,
no build step, no external requests. Served by GitHub Pages from this repository at
https://projectmax-org.github.io/ (the repository name is what makes it the organisation's root
site rather than a sub-path).

```
index.html            Project Max
driftwall/index.html  Driftwall
assets/               stylesheet, icons, screenshots
tools/serve.ps1       local preview on http://localhost:8080 (no dependencies)
```

## Publishing

1. Push to `main`. The workflow in `.github/workflows/pages.yml` deploys the repository as is.
2. In the repository settings, under **Pages**, set the source to **GitHub Actions**. That is all;
   the site is live at the address above within a minute, with HTTPS.

## Moving to a custom domain later

Links between pages are relative to the site root, but the address itself is written out in full
where search engines and link previews need it: the canonical links, the Open Graph tags and the
structured data in each page, `sitemap.xml` and `robots.txt`. Moving to another address means
replacing `https://projectmax-org.github.io/` with the new origin in `index.html`,
`driftwall/index.html`, `sitemap.xml` and `robots.txt` before the new domain goes live.

1. Register the domain (`projectmax.app` was free to register as of September 2026).
2. Add a file named `CNAME` at the repository root containing only the domain, commit and push.
3. In the repository settings under **Pages**, enter the same domain as the custom domain and,
   once the certificate is issued, tick **Enforce HTTPS**.
4. At the registrar, point the apex at GitHub Pages and `www` at the organisation's Pages host:

   | Record | Name | Value |
   |---|---|---|
   | A | @ | 185.199.108.153 |
   | A | @ | 185.199.109.153 |
   | A | @ | 185.199.110.153 |
   | A | @ | 185.199.111.153 |
   | AAAA | @ | 2606:50c0:8000::153, 2606:50c0:8001::153, 2606:50c0:8002::153, 2606:50c0:8003::153 |
   | CNAME | www | `projectmax-org.github.io` |

5. `driftwall.org`, if bought, is a redirect rather than a second site: at its registrar, forward
   the whole domain (apex and `www`, permanent 301, HTTPS) to the Driftwall page. Nothing needs to
   be deployed for it.
6. Search both repositories for `projectmax-org.github.io` before shipping: besides the pages, it appears in `AppPublisherURL` in `installer/Driftwall.iss`, the `/du` signing URL in `installer/build-installer.ps1`, `PackageProjectUrl` in `Driftwall.csproj` and the winget manifests. In particular, update the addresses the app and installer carry (`WebsiteUrl` in the Driftwall settings view
   model, `AppUrl` in the installer script, the user agents in `Net.cs` and `RedditSource.cs`) and
   the links in the Driftwall README, then ship a new release.

## Editing

Screenshots in `assets/screens` are 1180×760 window captures from the app; replace them when the UI
changes. The icon is `logo-512.png` from the Driftwall repository. Keep pages self-contained: one
stylesheet, inline SVG icons, no scripts.
