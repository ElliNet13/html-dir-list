# HTML Directory Listing Action

Generates index.html directory listings in every folder recursively using tree for use with Github pages.

# Usage
This is ment to be used with Github Pages in the deploy script. Here is an example for how to use this action to stick in:
```yaml
name: "Create HTML Directory Listings"
uses: ElliNet13/html-dir-list@version
with:
    dir: "."
    hideDotFiles: true
    displayLastModified: false
```

## What versions are available?
Check the releases if you want to make sure it won't update or if you want always the latest code you can use `main`.

# More Examples
Check `.github/workflows/deploy.yml` of this repo. (Click source code on the side)
