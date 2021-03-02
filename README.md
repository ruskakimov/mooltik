# Mooltik - animated movie maker

[![Codemagic build status](https://api.codemagic.io/apps/60363e65c9d4d7cf9b10cfc0/60363e65c9d4d7cf9b10cfbf/status_badge.svg)](https://codemagic.io/apps/60363e65c9d4d7cf9b10cfc0/60363e65c9d4d7cf9b10cfbf/latest_build)


## Useful commands:

#### Extract app data

```
adb backup -noapk com.your.packagename
( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 backup.ab ) |  tar xfvz -
```
