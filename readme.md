This repo records changes to software licenses.

To use these scripts, create a personal dev token in your GitHub settings.

This script adds recently updated repos (>1000) to `repos.txt`:

```bash
./repos.sh $GITHUB_TOKEN
```

This script samples `repos.txt` and adds the license commit history to
`commits.csv`:

```bash
./commits.sh $GITHUB_TOKEN
```

View the latest license changes like so:

```bash
cat commits.csv | sort -r | head
```

View the license commits on GitHub at `https://github.com/$REPO/commit/$COMMIT`
or via API:

```bash
curl -H "Accept: application/vnd.github+json" \
     -H "Authorization: token $GITHUB_TOKEN" \
     "https://api.github.com/repos/$REPO/commits/$COMMIT"
```
