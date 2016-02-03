# upgignore.sh
# comments and uncomments the .dockerignore
# is called from build_images.sh
PAT="$1"
MODE="$2"
FILE=./.dockerignore

if [[ "$MODE" == "uncomment" ]]
then
sed -e 's/^#\.\/'$PAT'/\.\/'$PAT'/' $FILE > .x
mv .x $FILE
cat $FILE
fi

if [[ "$MODE" == "comment" ]]
then
sed 's/\.\/'$PAT'/#\.\/'$PAT'/' $FILE > .x
mv .x $FILE
cat $FILE
fi

