# Mooltik - animatic maker

Work in progress...

Run the following command to extract app data:

```
adb backup -noapk com.your.packagename
( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 backup.ab ) |  tar xfvz -
```