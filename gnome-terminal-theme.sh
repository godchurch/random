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
        dset palette "['rgb(54,54,54)','rgb(233,84,99)','rgb(142,209,97)','rgb(226,151,48)','rgb(86,156,173)','rgb(240,101,190)','rgb(95,228,178)','rgb(201,201,201)','rgb(69,69,69)','rgb(233,84,99)','rgb(142,209,97)','rgb(226,151,48)','rgb(86,156,173)','rgb(240,101,190)','rgb(95,228,178)','rgb(255,255,255)']"
        dset background-color "'rgb(30,30,30)'"
        dset foreground-color "'rgb(229,229,229)'"
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

# Background   1E1E1E
# Foreground   E5E5E5

#  Black   Red     Green   Yellow  Blue    Magenta  Cyan    White
#  363636  E95463  8ED161  E29730  569CAD  F065BE   5FE4B2  C9C9C9
#  454545  E95463  8ED161  E29730  569CAD  F065BE   5FE4B2  FFFFFF
