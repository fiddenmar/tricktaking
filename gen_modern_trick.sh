#!/bin/bash

rootURL="https://my-domain-where-the-cards-are-stored/"
cardDestFolder="modern_trick"
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
    -pointsize 50 \
    -draw "text 135,0 '$1'" \
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
    $cardDestFolder/$2-$1.png

  rm $cardDestFolder/$2-$1-tmp.png
  echo $2-$1
}

colors=(
  RED
  BLUE
  YELLOW
  GREEN
)
counter=1
while [ $counter -le 13 ]; do
  for color in "${colors[@]}"; do
    label=$(create_card $color $counter)
    echo $label";"$rootURL$label.png";" >>$cardDestFolder/$csvFileName
  done
  ((counter++))
done
