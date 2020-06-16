#!/usr/bin/env bash

clear

URL=$(php create_hmac_url.php)
echo $URL | pbcopy

echo "Your test URL is:"
echo ""
echo "    " $URL
echo ""
echo "Hopefully you have pbcopy, or have otherwise aliased xsel or xclip to pbcopy. If so, the above URL is now in your clipboard."
echo ""