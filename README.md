# registration-titling

Demo Rails application. It registers and titles vehicles sold directly to
customers, issues temporary tags and records lien filings from lenders.

Everything here is invented for a demo. **The state and province rules, fees,
form names and deadlines are made up and are not real DMV rules.** The VINs
are not real and this is not Lucid code.

## What it does

1. `POST /registrations` creates a draft registration and issues a temporary
   tag.
2. `POST /registrations/:id/submit` works out the fees and either submits the
   registration or puts it on hold when documents are missing.
3. `POST /registrations/:id/lien_notice` accepts an XML notice from a lender
   and records a lien filing.

Rules differ for California, Texas, New York and Ontario. They are spread
across the models and services and are only partly covered by tests.

## Set up and test

```
bundle install
bin/rails db:schema:load
bin/rails test
```

`Gemfile.lock` is not committed yet. Commit it after the first
`bundle install`.

## Open finding

`security/FINDING-004.md`.

## Conventions

- Never push to `main`. Open a pull request.
- A pull request description lists what changed, the test results and the
  re-scan result.
- Do not change a state rule without a test that pins the old behavior
  first.
