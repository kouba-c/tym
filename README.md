# Tym
Write text to a image.

## Usage
Install font file.
[emulogic.ttf](http://www.fontspace.com/freaky-fonts/emulogic)

```
# bundle exec ruby bin/tym base.png text.tym
```

### base.png
![before](https://raw.githubusercontent.com/wiki/kouba-c/tym/img/base.png)

### text.tym
```
#FONTPATH=~/Library/Fonts/emulogic.ttf
#FONTSIZE=8
#COLOR=WHITE
#ALIGN=RIGHT
#POSITION_X=24
#POSITION_Y=6
MARIO          WORLD  TIME
123456    99    8-4    231
#ALIGN=CENTER
#POSITION_X=0
#POSITION_Y=64
THANK YOU MARIO!


YOUR QUEST IS OVER.

WE PRESENT YOU A NEW QUEST.


PUSH BUTTON B

TO SELECT A WORLD
```

### base_tym.png(output img)
![after](https://raw.githubusercontent.com/wiki/kouba-c/tym/img/base_tym.png)
