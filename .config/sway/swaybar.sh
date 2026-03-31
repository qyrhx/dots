#!/bin/bash
# Keyboard input name
keyboard_input_name="1:1:AT_Translated_Set_2_keyboard"

# Date and time
date_and_week=$(date "+%A -- %Y-%m-%d")
current_time=$(date "+%H:%M")
# Battery or charger
battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | grep -E "percentage" | awk '{print $2}')
battery_num=${battery_charge::-1}
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | grep -E "state" | awk '{print $2}')
time_to_empty=$(upower -i $(upower -e | grep BAT) | grep "time to empty" | awk '{print $4, $5}')
battery_pluggedin=" "
if [[ -z $time_to_empty ]]
then
    time_to_empty=" "
else
    time_to_empty=" (${time_to_empty})"
fi

brightness=$(brightnessctl get | awk -v max=$(brightnessctl max) '{print int($1 / max * 100)}')

# Audio and multimedia
audio_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+?(?=%)' | head -1)
audio_is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep yes -o)
audio_active='🕪'
media_artist=$(playerctl metadata artist)
media_song=$(playerctl metadata title)
media_song_and_artist="${media_artist} - ${media_song}"
max_media_len=60
if [[ ${#media_song_and_artist} -gt $max_media_len ]] then
   #media_song_and_artist="${media_song_and_artist:0:$max_media_len}..."
   media_song_and_artist="$(echo "$media_song_and_artist" | awk -v max_len="$max_media_len" 'BEGIN {FS=""} {for (i=1; i<=max_len; i++) printf "%s", $i; print ""}' | sed 's/ *$//')..."
fi

   player_status=$(playerctl status)

   # Others
   language=$(swaymsg -r -t get_inputs | awk '/1:1:AT_Translated_Set_2_keyboard/;/xkb_active_layout_name/' | grep -A1 '\b1:1:AT_Translated_Set_2_keyboard\b' | grep "xkb_active_layout_name" | awk -F '"' '{print $4}')

   if [[ $battery_status = "discharging" ]]
   then
       if [[ $battery_num -le 10 ]]
       then
           battery_charge="⚠⚠ ${battery_charge} ⚠⚠"
       fi
   else
       battery_charge="${battery_charge} C"
   fi

   if [[ $player_status = 'Playing' ]]
   then
       song_status='⏸'
   elif [[ $player_status = "Paused" ]]
   then
       song_status='▶'
   else
       song_status='⏹'
   fi

   if [[ $audio_is_muted = "yes" ]]
   then
       audio_active="$audio_active M"
   fi

   echo "$song_status $media_song_and_artist | ⌨ $language | ☀ $brightness% | $audio_active $audio_volume% | $battery_pluggedin$battery_charge$time_to_empty | $date_and_week | 󰅐 $current_time"
