#!/usr/bin/env bash

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME=Custom
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG=Custom
[[ -z "$DCONF" ]] && DCONF=dconf
[[ -z "$UUIDGEN" ]] && UUIDGEN=uuidgen

dset() {
    local key="$1"; shift
    local val="$1"; shift

    if [[ "$type" == "string" ]]; then
        val="'$val'"
    fi

    "$DCONF" write "$PROFILE_KEY/$key" "$val"
}

# because dconf still doesn't have "append"
dlist_append() {
    local key="$1"; shift
    local val="$1"; shift

    local entries="$(
        {
            "$DCONF" read "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$val"
            echo "'$val'"
        } | head -c-1 | tr "\n" ,
    )"

    "$DCONF" write "$key" "[$entries]"
}

# Newest versions of gnome-terminal use dconf
if which "$DCONF" > /dev/null 2>&1; then
    [[ -z "$BASE_KEY_NEW" ]] && BASE_KEY_NEW=/org/gnome/terminal/legacy/profiles:

    if [[ -n "`$DCONF list $BASE_KEY_NEW/`" ]]; then
        if which "$UUIDGEN" > /dev/null 2>&1; then
            PROFILE_SLUG=`uuidgen`
        fi

        if [[ -n "`$DCONF read $BASE_KEY_NEW/default`" ]]; then
            DEFAULT_SLUG=`$DCONF read $BASE_KEY_NEW/default | tr -d \'`
        else
            DEFAULT_SLUG=`$DCONF list $BASE_KEY_NEW/ | grep '^:' | head -n1 | tr -d :/`
        fi

        DEFAULT_KEY="$BASE_KEY_NEW/:$DEFAULT_SLUG"
        PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"

        # copy existing settings from default profile
        $DCONF dump "$DEFAULT_KEY/" | $DCONF load "$PROFILE_KEY/"

        # add new copy to list of profiles
        dlist_append $BASE_KEY_NEW/list "$PROFILE_SLUG"

        # update profile values with theme options
        dset visible-name "'$PROFILE_NAME'"
        dset palette "['rgb(24,24,24)','rgb(172,66,66)','rgb(144,169,89)','rgb(244,191,117)','rgb(106,159,181)','rgb(170,117,159)','rgb(117,181,170)','rgb(216,216,216)','rgb(107,107,107)','rgb(197,85,85)','rgb(170,196,116)','rgb(254,202,136)','rgb(130,184,200)','rgb(194,140,184)','rgb(147,211,195)','rgb(248,248,248)']"
        dset background-color "'rgb(24,24,24)'"
        dset foreground-color "'rgb(216,216,216)'"
        dset use-theme-colors "false"
        dset use-theme-transparency "false"
        dset use-transparent-background "true"
        dset background-transparency-percent "5"

        unset PROFILE_NAME
        unset PROFILE_SLUG
        unset DCONF
        unset UUIDGEN
    fi
fi

# ! special
# *.foreground:   #d8d8d8
# *.background:   #181818
# *.cursorColor:  #d8d8d8
#
# ! black
# *.color0:       #181818
# *.color8:       #6B6B6B
#
# ! red
# *.color1:       #AC4242
# *.color9:       #C55555
#
# ! green
# *.color2:       #90A959
# *.color10:      #AAC474
#
# ! yellow
# *.color3:       #F4BF75
# *.color11:      #FECA88
#
# ! blue
# *.color4:       #6A9FB5
# *.color12:      #82B8C8
#
# ! magenta
# *.color5:       #AA759F
# *.color13:      #C28CB8
#
# ! cyan
# *.color6:       #75B5AA
# *.color14:      #93D3C3
#
# ! white
# *.color7:       #D8D8D8
# *.color15:      #F8F8F8
