# helm-OS Versioning and Update System

## Files
- version.txt: Local version identifier.
- latest.txt: Remote version identifier stored in GitHub.
- check_update.sh: Script that compares local and remote versions.
- update_instructions.html: User-facing update guide.

## How to Release a New Version
1. Update version.txt in the repo.
2. Update latest.txt with the new version number.
3. Commit and push both files.
4. Update install.sh if needed.
5. Tag the release in GitHub.

## How helm-OS Checks for Updates
- The UI runs check_update.sh.
- If the script returns "update-available", the UI shows a banner.
- The banner links to update_instructions.html.

## Beta Builds
Any version containing "beta" in version.txt will display a beta warning banner.
