#!/bin/bash
set -e
rm -rf PreviewFonts XmlFonts XmlFontsRenamed RecompiledFonts RepackedFonts || true
mkdir -p PreviewFonts XmlFonts XmlFontsRenamed RecompiledFonts RepackedFonts || true

IFS="
"
fonts="
OriginalFonts/ubuntu-font-family-0.83/UbuntuMono-R.ttf:UbuntuMono
OriginalFonts/jetbrainsmono/JetBrainsMono-Regular.ttf:DejaVuSansMono"
for fontandname in $fonts
do
	font="$(echo "$fontandname" | cut -d ":" -f 1)"
	fontpsname="$(echo "$fontandname" | cut -d ":" -f 2)"
	fontname="$(basename -s .otf "$(basename -s .ttf "$font")")"

	cp "$font" PreviewFonts/

	ttx -d XmlFonts "$font"
	sed -e "s/$fontpsname/.SFUI-Regular/g" "XmlFonts/$fontname.ttx" > "XmlFontsRenamed/$fontname.ttx"
	ttx -d RecompiledFonts --flavor woff2 "XmlFontsRenamed/$fontname.ttx"

	./BrotliPadding "RecompiledFonts/$fontname.woff2" "RepackedFonts/$fontname.woff2"
done
