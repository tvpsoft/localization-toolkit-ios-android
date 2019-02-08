
#link to localization sheet
localizationGoogleDriveID='ID'
#link to localization sheet
localizationGoogleDriveLink="https://docs.google.com/spreadsheets/d/$localizationGoogleDriveID/export?format=tsv&id=$localizationGoogleDriveID&gid=0"

curl -s $localizationGoogleDriveLink > temploc

#leave script resource is unavailable
if [[ $? != 0 ]]; then
  echo "Resource is unavailable"
  rm temploc
  exit 0
fi

#list of available localizations in the same order as in localization sheet
declare -a localizations=(fr en es) #ru vi de it pt zh-CN zh-TW ja ko id ms hi ar)

#index of column containing android localization key
keyIndex=2
#index of first localization column in sheet file
firstLocIndex=3
#root of languages folder
rootDir='./'

# if current localization column (currentLocIndex) value is empty, set english localization (firstLocIndex)
awkscript='
{
	if ($keyIndex != "" && $keyIndex != "Identifier Android") {
		if ($currentLocIndex == "") {
			actualLocIndex=firstLocIndex
		}
		gsub(/"/,"\\\"",$actualLocIndex);
    gsub("%@", "%s", $actualLocIndex);
    gsub("%i", "%d", $actualLocIndex);
    gsub("%i", "%d", $actualLocIndex);
    gsub("=", "=", $actualLocIndex);
    gsub("%1$s", "%s", $actualLocIndex);
    gsub("'"'"'", "\\'"'"'", $actualLocIndex);
		print "\t<string name=\""$keyIndex"\">"$actualLocIndex"</string>";
		actualLocIndex=currentLocIndex
	}
}
'

for i in "${!localizations[@]}"
do
  currentLocIndex=$(( $i + $firstLocIndex ))
  extension=${localizations[$i]}
  prefix='values-'
  directory=$prefix$extension
  rm -rf $rootDir$directory; mkdir $rootDir$directory;
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<resources>" > $rootDir$directory/strings.xml
  cat temploc | awk -v firstLocIndex="$firstLocIndex" -v currentLocIndex="$currentLocIndex" -v actualLocIndex="$currentLocIndex" -v keyIndex="$keyIndex" -F "\t"  "$awkscript" | tee -a $rootDir$directory/strings.xml
  echo "</resources>" >> $rootDir$directory/strings.xml
done

rm temploc
