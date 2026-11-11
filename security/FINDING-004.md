# FINDING-004: vulnerable dependency rexml

| Field | Value |
| --- | --- |
| Severity | High |
| Advisory | CVE-2024-35176 |
| Package | rexml (RubyGems) |
| Installed version | 3.2.6 |
| Fixed version | 3.2.7 or later |
| Affected area | XML parsing of documents with many `<` characters in attribute values |
| Source | Dependency scan of `Gemfile` |
| Due | 30 days from detection under the policy for high findings |

## Summary

Parsing a crafted XML document can take a very long time. If the application
parses XML from an untrusted source, an attacker can cause a denial of
service.

## What the security team needs to close this

- Whether untrusted XML reaches REXML in this application.
- The upgrade, with the tests passing. Test coverage here is thin, so say
  what the tests do and do not cover.
- A re-scan showing the advisory no longer applies.

This finding was written by hand for a demo. Replace it with real scanner
output before presenting.
