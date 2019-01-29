#link to localization sheet
localizationGoogleDriveLink='https://docs.google.com/spreadsheets/d/1rDXDuGLowd_9L9TQRwAEjBj146eoVI4F7FpgZrqOrRk/export?format=tsv&id=1rDXDuGLowd_9L9TQRwAEjBj146eoVI4F7FpgZrqOrRk&gid=0'

curl -s $localizationGoogleDriveLink > temploc

#leave script resource is unavailable
if [[ $? != 0 ]]; then
  echo "Resource is unavailable"
  rm temploc
  exit 0
fi

#list of available localizations in the same order as in localization sheet
declare -a localizations=(fr en es) #ru vi de it pt zh-CN zh-TW ja ko id ms hi ar)

#index of column containing ios localization key
keyIndex=1

#index of first localization column in sheet file
firstLocIndex=3

#generation of iOS localization files
rm -rf Localizable; mkdir Localizable;
rm -rf InfoPlist; mkdir InfoPlist;

# if current localization column (currentLocIndex) value is empty, set english localization (firstLocIndex)
awkscript='
{ 
	if ($keyIndex != "") { 
		if ($currentLocIndex == "") { 
			actualLocIndex=firstLocIndex 
		}
		gsub(/"/,"\\\"",$actualLocIndex);
                gsub("%s", "%@", $actualLocIndex); 
		print "\""$keyIndex"\" = \""$actualLocIndex"\";"; 
		actualLocIndex=currentLocIndex 
	}
}
'

for i in "${!localizations[@]}"
do
  currentLocIndex=$(( $i + $firstLocIndex ))
  prefix=${localizations[$i]}
  extension=".lproj"
  directory=$prefix$extension
  mkdir ./Localizable/$directory
  mkdir ./InfoPlist/$directory
  cat temploc | awk -v firstLocIndex="$firstLocIndex" -v currentLocIndex="$currentLocIndex" -v actualLocIndex="$currentLocIndex" -v keyIndex="$keyIndex" -F "\t"  "$awkscript" | tee ./Localizable/$directory/Localizable.strings | grep '^"NS.*UsageDescription"' > InfoPlist/$directory/InfoPlist.strings
done

rm temploc