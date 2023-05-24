#!/bin/bash

rootURL="https://my-domain-where-the-cards-are-stored/"
cardDestFolder="veloscout"
csvFileName="import.csv"

while [[ $# -gt 0 ]]; do
  key="$1"
  case ${key} in
  -dest)
    cardDestFolder="$2"
    shift
    ;;
  -root)
    rootURL="$2"
    shift
    ;;
  *)
    # A "random" parameter is presumed to be the destination
    # Typically that will be specified at the end, or as the only
    # parameter.
    cardDestFolder="$1"
    ;;
  esac
  shift
done

echo "label;image;" >$cardDestFolder/$csvFileName

#create normal cards
#$1 color
#$2 number
#$3 points
function create_card() {
  convert \
    -size 412x120 \
    xc:white \
    -stroke black \
    -font Bookman-DemiItalic \
    -pointsize 100 \
    -fill $1 \
    -gravity NorthWest \
    -draw "text 0,0 '$2'" \
    $cardDestFolder/$2-$1-tmp.png

  # if [ "$3" != "" ]; then
  #   rectangleXStart=133
  #   if [ "$3" -lt 10 ]; then
  #     ((rectangleXEnd=rectangleXStart+60))
  #   else
  #     ((rectangleXEnd=rectangleXStart+100))
  #   fi
  #   convert $cardDestFolder/$2-$1-tmp.png \
  #     -fill $1 \
  #     -stroke black \
  #     -draw "rectangle ${rectangleXStart},48 ${rectangleXEnd},115" \
  #     -fill white \
  #     -gravity NorthWest \
  #     -font Bookman-DemiItalic \
  #     -pointsize 70 \
  #     -draw "text 135,50 '$3'" \
  #     $cardDestFolder/$2-$1-tmp.png
  # fi
  count="$(ls $cardDestFolder/*.png | wc -l)"
  convert \
    -size 412x640 \
    xc:white \
    -draw "image over 15,15 0,0 '${cardDestFolder}/${2}-${1}-tmp.png'" \
    -stroke black \
    -font Bookman-Demi \
    -fill $1 \
    -gravity center \
    -pointsize 150 \
    -draw "text 0,0 '$2'" \
    -fill none \
    -draw "polyline 100,200 100,440 312,440 312,200 100,200" \
    -gravity SouthEast \
    -draw "rotate 180 image over 405,85 0,0 '${cardDestFolder}/${2}-${1}-tmp.png'" \
    $cardDestFolder/$2-$count.png

  rm $cardDestFolder/$2-$1-tmp.png
  echo $2-$1
}

values=(1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 3 4 4 4 4 4 4 4 5 5 5 5 5 5 5 6 6 6 6 6 6 6 11 11 11 11 22 22 22 22 33 33 33 33 44 44 44 44 55 55 55 55 12 12 21 21 23 23 32 32 34 34 43 43 45 45 54 54 56 56)
last_value=0
for value in "${values[@]}";
do
  label=$(create_card BLACK $value)
  echo $label";"$rootURL$label.png";" >>$cardDestFolder/$csvFileName
done
