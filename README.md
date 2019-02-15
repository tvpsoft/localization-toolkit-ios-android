# Localization toolkit  for iOS and Android

This is the script for export the localization using Google Sheet in formats needed of iOS and Android. 

## Parameters 

| Param | Description |
|-------|-------------|
|localizationGoogleDriveID | The Id of GoogleSheet document, make sure the doc can be accessed by public with link |
|localizationSheetID | the sheetID, default 0 |
|keyIndex  | index of column containing ios localization key |
|firstLocIndex  | index of first localization column in sheet file |
|rootDir  | default is script folder. Change to the folder of the localization files located, you can save the time of copy, paste files | 

## Use

for IOS

```
$ ./getLocalizationIOS.sh 

```

for Android

```
$ ./getLocalizationAndroid.sh 

```

## Screenshot

![sheet](https://raw.githubusercontent.com/tvpsoft/localization-toolkit-ios-android/master/localsheet.png)

![android](https://raw.githubusercontent.com/tvpsoft/localization-toolkit-ios-android/master/android.png)

![ios](https://raw.githubusercontent.com/tvpsoft/localization-toolkit-ios-android/master/ios.png)

