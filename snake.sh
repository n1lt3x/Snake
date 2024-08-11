#!/bin/bash

width=20
height=10

snakeX=5
snakeY=5

direction="RIGHT"

snake=("$snakeX,$snakeY")

length=1

foodX=$((RANDOM % width))
foodY=$((RANDOM % height))


delay=0.2


draw() {
  clear
  for ((y=0; y<height; y++)); do
    for ((x=0; x<width; x++)); do
      if [[ "$x,$y" == "$foodX,$foodY" ]]; then
        echo -n "O"  # Essen
      elif [[ "$x,$y" == "$snakeX,$snakeY" ]]; then
        echo -n "#"  # Schlangenkopf
      else
        found="false"
        for part in "${snake[@]}"; do
          if [[ "$x,$y" == "$part" ]]; then
            echo -n "#"  # Schlangenkörper
            found="true"
            break
          fi
        done
        if [ "$found" == "false" ]; then
          echo -n "."  # Leerraum
        fi
      fi
    done
    echo
  done
}


update_position() {
  case $direction in
    "UP") ((snakeY--)) ;;
    "DOWN") ((snakeY++)) ;;
    "LEFT") ((snakeX--)) ;;
    "RIGHT") ((snakeX++)) ;;
  esac


  if [ $snakeX -ge $width ]; then snakeX=0; fi
  if [ $snakeX -lt 0 ]; then snakeX=$((width-1)); fi
  if [ $snakeY -ge $height ]; then snakeY=0; fi
  if [ $snakeY -lt 0 ]; then snakeY=$((height-1)); fi


  if [[ "$snakeX,$snakeY" == "$foodX,$foodY" ]]; then
    ((length++))
    foodX=$((RANDOM % width))
    foodY=$((RANDOM % height))
  fi


  snake=("$snakeX,$snakeY" "${snake[@]:0:$((length-1))}")
}


check_collision() {
  for part in "${snake[@]:1}"; do
    if [[ "$snakeX,$snakeY" == "$part" ]]; then
      echo "Game Over! Länge der Schlange: $length"
      exit 0
    fi
  done
}


keypress() {
  read -rsn1 -t $delay key
  case $key in
    w) if [ "$direction" != "DOWN" ]; then direction="UP"; fi ;;
    s) if [ "$direction" != "UP" ]; then direction="DOWN"; fi ;;
    a) if [ "$direction" != "RIGHT" ]; then direction="LEFT"; fi ;;
    d) if [ "$direction" != "LEFT" ]; then direction="RIGHT"; fi ;;
  esac
}

# Hauptschleife
while true; do
  draw
  keypress
  update_position
  check_collision
done
