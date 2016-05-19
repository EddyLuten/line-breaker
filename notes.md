# Dev Notes

Sorry, folks, I keep forgetting the process since I don't do this very often.

## Developing

```bash
apm develop line-breaker
apm install
atom -d
```

`atom -d` opens up an instance of Atom with the package loaded in dev mode.

## Publishing

Don't update the version number in `package.json`, but update `CHANGELOG.md`

Git add / commit, then:

```bash
apm publish <version>
```
