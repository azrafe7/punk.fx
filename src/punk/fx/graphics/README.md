Extended FlashPunk graphics classes that implement IFXGraphic.

Since all of these classes share the majority of code I'm using a preprocessor to generate it,
thus keeping all the shared code centralized and potentially avoiding to introduce bugs in multiple locations.
I'm using FMPP as an Ant Task to convert .ax files to proper .as files by applying a custom template.

The reason for this approach is that AS3 doesn't support multiple inheritance, but an FXSpritemap class
is supposed to extend both Spritemap and FXImage. Hence the work-around.