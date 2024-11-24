# config.sile

The support for configuration files was originally made for my first attempt to create a module for SILE, the now archived repo [extend.sile](https://github.com/jodros/extend.sile)...


The idea is to pass any options, settings and even framesets through a `toml` file. Actually, two files, the default being stored in `~/.config/sile/default.toml`, and the second one in user's working directory, called `settings.toml`, which could overwrite anything in the default.

The basic structure is:

```toml
[options]
papersize = "a4"

[settings]
document.language = "en"

[scratch]

[frames]

```

The `options` table refers only to **class options** and in the same way `settings` has to do only with declared settings, e.g. `document.parskip`... The scratch table could be used when one is creating a command, lets say it's called `chapter`, and wants to pass the options like this:

```toml
[scratch.chapter]
indent = true # for the first paragraph
case = "uppercase"
```

And then one could access these values using `SILE.scratch.chapter[option]`...

About the frames, an actual example is:

```toml
[frames.right.content]
left = "(100%pw-50%ph)/2"
right = "100%pw-((100%pw-50%ph)/2)"
top = "(100%ph-100%pw)/2"
bottom = "top(footnotes)-1%ph"
[frames.right.folio]
left = "left(content)"
right = "right(content)"
top = "bottom(footnotes)+3%ph"
bottom = "bottom(footnotes)+5%ph"
[frames.right.footnotes]
left = "left(content)"
right = "right(content)"
bottom = "90%ph"
height = "0"
```

So one could call `SILE.scratch.frames.right` when creating a new master.

## Installing

Just clone this repository and then run `luarocks --local make`. LuaRocks will automatically install the dependencies if you don't have them yet...

