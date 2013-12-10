#!/bin/sh

SourceDir="$1"
FolderName="$2"

pushd "$SourceDir" > /dev/null || { echo "$SourceDir not found"; exit 1; }
SourceDir=`pwd` 
popd > /dev/null

ClassFolderName=`basename $SourceDir`
DestFolder="`pwd`/Classes/$ClassFolderName";

if [ -d "$DestFolder" ]; then
	rm -rd "$DestFolder"
fi

mkdir -p "$DestFolder"

echo "Searching in \"$SourceDir\""

dirs=`find "$SourceDir" -depth 1 -type d`

for dir in $dirs; do	
	theFolder=`basename $dir`
	theFolder="$DestFolder/$theFolder"

	mkdir "$theFolder"
	
	toFind="$dir/$FolderName"
	
	if [ -d "$toFind" ]; then
		
		echo "Found Files in \"$toFind\""

		files=`find "$toFind" -name "*.[mh]"`


		for file in $files; do
			srcFile="$file"
			destFile=`basename "$file"`
			destFile="$theFolder/$destFile" 
# 			echo "old: $srcFile"
# 			echo "new: $destFile"
			
			ln -fs "$srcFile" "$destFile"
		done
	fi
done