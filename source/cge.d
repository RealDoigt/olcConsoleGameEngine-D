/*
IMPORTANT: 
Below is copied as is from the original C++ source code. All uses of "I" and "my" in the text refer to Javidx9

OneLoneCoder.com - Command Line Game Engine
"Who needs a frame buffer?" - @Javidx9
The Original & Best :P
One Lone Coder License
~~~~~~~~~~~~~~~~~~~~~~
- This software is Copyright (C) 2018 Javidx9
- This is free software
- This software comes with absolutely no warranty
- The copyright holder is not liable or responsible for anything
  this software does or does not
- You use this software at your own risk
- You can distribute this software
- You can modify this software
- Redistribution of this software or a derivative of this software
  must attribute the Copyright holder named above, in a manner
  visible to the end user
License
~~~~~~~
One Lone Coder Console Game Engine  Copyright (C) 2018  Javidx9
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions; See license for details.
Original works located at:
	https://www.github.com/onelonecoder
	https://www.onelonecoder.com
	https://www.youtube.com/javidx9
GNU GPLv3
	https://github.com/OneLoneCoder/videos/blob/master/LICENSE
From Javidx9 :)
~~~~~~~~~~~~~~~
Hello! Ultimately I don't care what you use this for. It's intended to be
educational, and perhaps to the oddly minded - a little bit of fun.
Please hack this, change it and use it in any way you see fit. You acknowledge
that I am not responsible for anything bad that happens as a result of
your actions. However this code is protected by GNU GPLv3, see the license in the
github repo. This means you must attribute me if you use it. You can view this
license here: https://github.com/OneLoneCoder/videos/blob/master/LICENSE
Cheers!
Background
~~~~~~~~~~
If you've seen any of my videos - I like to do things using the windows console. It's quick
and easy, and allows you to focus on just the code that matters - ideal when you're 
experimenting. Thing is, I have to keep doing the same initialisation and display code
each time, so this class wraps that up.
Author
~~~~~~
Twitter: @javidx9	http://twitter.com/javidx9
Blog:				http://www.onelonecoder.com
YouTube:			http://www.youtube.com/javidx9
Videos:
~~~~~~
Original:				https://youtu.be/cWc0hgYwZyc
Added mouse support:	https://youtu.be/tdqc9hZhHxM
Beginners Guide:		https://youtu.be/u5BhrA8ED0o
Shout Outs!
~~~~~~~~~~~
Thanks to cool people who helped with testing, bug-finding and fixing!
wowLinh, JavaJack59, idkwid, kingtatgi, Return Null, CPP Guy, MaGetzUb
Last Updated: 02/07/2018

See my other videos for examples!
http://www.youtube.com/javidx9
Lots of programs to try:
http://www.github.com/OneLoneCoder/videos
Chat on the Discord server:
https://discord.gg/WhwHUMV
Be bored by Twitch:
http://www.twitch.tv/javidx9
*/

module olc_console_game_engine;
import arsd.terminal;
import std.file;
import std.conv;

enum BLACK        = 0;
enum DARK_BLUE    = BLUE_BIT;
enum DARK_GREEN   = GREEN_BIT;
enum DARK_CYAN    = DARK_BLUE    | DARK_GREEN;
enum DARK_RED     = RED_BIT;
enum DARK_MAGENTA = DARK_BLUE    | DARK_RED;
enum DARK_YELLOW  = DARK_RED     | DARK_GREEN;
enum GREY         = DARK_BLUE    | DARK_GREEN | DARK_RED;
enum DARK_GREY    = BLACK        | Bright;
enum BLUE         = DARK_BLUE    | Bright;
enum GREEN        = DARK_GREEN   | Bright;
enum RED          = DARK_RED     | Bright;
enum MAGENTA      = DARK_MAGENTA | Bright;
enum YELLOW       = DARK_YELLOW  | Bright;
enum WHITE        = GREY         | Bright;

enum PIXEL : wchar
{
    SOLID         = '█',
    THREEQUARTERS = '▓',
    HALF          = '▒',
    QUARTER       = '░'
}

class Sprite
{
    this(){}
    
    this(int w, int h)
    {
        create(w, h);
    }
    
    this (string file)
    {
        if (!load(file)) create(8, 8);
    }
    
    int width, height;
    
    private
    {
        wchar[] glyphs;
        short[] colours;
        
        void create(int w, int h)
        {
            width = w;
            height = h;
            
            int length = w * h;
            
            glyphs = new wchar[](length);
            colours = new short[](length);
            
            for (int i; i < length; ++i)
                glyphs[i] = ' ';
        }
    }
    
    void setGlyph(int x, int y, wchar c)
    {
        if (x < 0 || x >= width || y < 0 || y >= height) 
            return;
            
        glyphs[y * width + x] = c;
    }
    
    void setColour(int x, int y, short c)
    {
        if (x < 0 || x >= width || y < 0 || y >= height) 
            return;
            
        colours[y * width + x] = c;
    }
    
    auto getGlyph(int x, int y)
    {
        if (x < 0 || x >= width || y < 0 || y >= height) 
            return ' ';
            
        return glyphs[y * width + x];
    }
    
    auto getColour(int x, int y)
    {
        if (x < 0 || x >= width || y < 0 || y >= height) 
            return BLACK;
            
        return colours[y * width + x];
    }
    
    auto sampleGlyph(float x, float y)
    {
        int sx = cast(int)(x * cast(float)width),
            sy = cast(int)(y * cast(float)height - 1f);
            
        if (sx < 0 || sx >= width || sy < 0 || sy >= height)
            return ' ';
            
        return glyphs[sy * width + sx];
    }
    
    auto sampleColour(float x, float y)
    {
        int sx = cast(int)(x * cast(float)width),
            sy = cast(int)(y * cast(float)height - 1f);
            
        if (sx < 0 || sx >= width || sy < 0 || sy >= height)
            return BLACK;
            
        return colours[sy * width + sx];
    }
    
    void save(string fileName)
    {
        auto file = File(fileName, "wb");
        
        file.rawWrite([width]);
        file.rawWrite([height]);
        file.rawWrite(colours);
        file.rawWrite(glyphs);
    }
    
    auto load(string fileName)
    {
        auto file = File(fileName, "rb");
        if (!fileName.exists) return false;

        width = file.rawRead(new int[](1))[0];
        height = file.rawRead(new int[](1))[0];
        auto length = width * height;

        colours = file.rawRead(new short[](length));
        glyphs = file.rawRead(new wchar[](length));

        return true;
    }
}