#!/usr/bin/env python

import math
from gimpfu import *

def draw_square(tdrawable, posx, posy, len):
	len = len - 1
	pdb.gimp_pencil(tdrawable, 4, [posx, posy, posx + len, posy])
	pdb.gimp_pencil(tdrawable, 4, [posx + len, posy, posx + len, posy + len])
	pdb.gimp_pencil(tdrawable, 4, [posx + len, posy + len, posx, posy + len])
	pdb.gimp_pencil(tdrawable, 4, [posx, posy + len, posx, posy])


def generate_object_template(timg, tdrawable, width, height, patternx, patterny, patternz, animations, layers, labeled):
	imageWidth = int(32 * width * patternx * layers)
	imageHeight = int(32 * height * patterny * patternz * animations)

	image = gimp.Image(imageWidth, imageHeight, RGB)
	image.disable_undo()

	gimp.set_foreground(0, 0, 0)

	template_layer = gimp.Layer(image, "Template", imageWidth, imageHeight, RGBA_IMAGE, 100, NORMAL_MODE)
	pdb.gimp_image_insert_layer(image, template_layer, None, 0)

	label_layer = None
	if labeled:
		label_layer = gimp.Layer(image, "Labels", imageWidth, imageHeight, RGBA_IMAGE, 100, NORMAL_MODE)
		pdb.gimp_image_insert_layer(image, label_layer, None, -1)

	pdb.gimp_context_set_brush("Circle (01)")
	font = "Verdana"
	disp = gimp.Display(image)

	for z in range(0, int(patternz)):
		for y in range(0, int(patterny)):
			for x in range(0, int(patternx)):
				for l in range(0, int(layers)):
					for a in range(0, int(animations)):
						for w in range(0, int(width)):
							for h in range(0, int(height)):
								posX = int(32 * (width - w - 1 + width * x + width * patternx * l))
								posY = int(32 * (height - h - 1 + height * y + height * patterny * a + height * patterny * animations * z))
								if not labeled:
									new_layer = gimp.Layer(image, "W(%i) H(%i) A(%i) L(%i) X(%i) Y(%i) Z(%i)" % (w, h, a, l, x, y, z), 32, 32, RGBA_IMAGE, 100, NORMAL_MODE)
									pdb.gimp_image_insert_layer(image, new_layer, None, -1)
									pdb.gimp_layer_set_offsets(new_layer, posX, posY)
									pdb.gimp_image_set_active_layer(image, new_layer)
									draw_square(new_layer, 0, 0, 32)
								else:
									draw_square(label_layer, posX, posY, 32)
									posX = posX + 2
									pdb.gimp_text_fontname(image, label_layer, posX, posY, "W" + str(w), -1, False, 9, 0, font)
									pdb.gimp_text_fontname(image, label_layer, posX, posY + 7, "H" + str(h), -1, False, 9, 0, font)
									pdb.gimp_text_fontname(image, label_layer, posX, posY + 14, "A" + str(a), -1, False, 9, 0, font)
									pdb.gimp_text_fontname(image, label_layer, posX, posY + 22, "L" + str(l), -1, False, 9, 0, font)
									pdb.gimp_text_fontname(image, label_layer, posX + 16, posY, "X" + str(x), -1, False, 9, 0, font)
									pdb.gimp_text_fontname(image, label_layer, posX + 16, posY + 9, "Y" + str(y), -1, False, 9, 0, font)
									pdb.gimp_text_fontname(image, label_layer, posX + 16, posY + 18, "Z" + str(z), -1, False, 9, 0, font)

	if labeled:
		image.merge_visible_layers(CLIP_TO_IMAGE)
	else:
		pdb.gimp_image_set_active_layer(image, template_layer)
	image.enable_undo()

register(
	"generate_object_template",
	"Generate a template for your object",
	"Generate a template for your object",
	"Summ",
	"Summ",
	"2013",
	"<Image>/File/Create/Gene_rate Object Template",
	"",
	[
		(PF_SPINNER, "Object_Width", "Object Width", 1, (1, 10, 1)),
		(PF_SPINNER, "Object_Height", "Object Height", 1, (1, 10, 1)),
		(PF_SPINNER, "Object_PatternX", "PatternX", 1, (1, 10, 1)),
		(PF_SPINNER, "Object_PatternY", "PatternY", 1, (1, 10, 1)),
		(PF_SPINNER, "Object_PatternZ", "PatternZ", 1, (1, 10, 1)),
		(PF_SPINNER, "Object_Animation_Phases", "Animation Phases", 1, (1, 10, 1)),
		(PF_SPINNER, "Object_Layers", "Layers", 1, (1, 10, 1)),
		(PF_BOOL, "Labeled", "Labeled (Yes), Layered (No)", False)
	],
	[],
	generate_object_template)

main()
