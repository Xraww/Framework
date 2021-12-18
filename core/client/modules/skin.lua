local Components = {
	{label = ('sex'),						name = 'sex',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('mom'),						name = 'mom',				value = 21,		min = 21,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('dad'),						name = 'dad',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('resemblance'),				name = 'face_md_weight',	value = 50,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('skin_tone'),				    name = 'skin_md_weight',	value = 50,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('nose_1'),					name = 'nose_1',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('nose_2'),					name = 'nose_2',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('nose_3'),					name = 'nose_3',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('nose_4'),					name = 'nose_4',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('nose_5'),					name = 'nose_5',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('nose_6'),					name = 'nose_6',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('cheeks_1'),				    name = 'cheeks_1',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('cheeks_2'),				    name = 'cheeks_2',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('cheeks_3'),				    name = 'cheeks_3',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('lip_fullness'),			    name = 'lip_thickness',		value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('jaw_bone_width'),			name = 'jaw_1',				value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('jaw_bone_length'),			name = 'jaw_2',				value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('chin_height'),				name = 'chin_1',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('chin_length'),				name = 'chin_2',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('chin_width'),				name = 'chin_3',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('chin_hole'),				    name = 'chin_4',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('neck_thickness'),			name = 'neck_thickness',	value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('hair_1'),					name = 'hair_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('hair_2'),					name = 'hair_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('hair_color_1'),			    name = 'hair_color_1',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('hair_color_2'),			    name = 'hair_color_2',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = ('tshirt_1'),				    name = 'tshirt_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 8},
	{label = ('tshirt_2'),				    name = 'tshirt_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'tshirt_1'},
	{label = ('torso_1'),					name = 'torso_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 11},
	{label = ('torso_2'),					name = 'torso_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'torso_1'},
	{label = ('decals_1'),				    name = 'decals_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 10},
	{label = ('decals_2'),				    name = 'decals_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'decals_1'},
	{label = ('arms'),					    name = 'arms',				value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = ('arms_2'),					name = 'arms_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = ('pants_1'),					name = 'pants_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5,	componentId	= 4},
	{label = ('pants_2'),					name = 'pants_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5,	textureof	= 'pants_1'},
	{label = ('shoes_1'),					name = 'shoes_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8,	componentId	= 6},
	{label = ('shoes_2'),					name = 'shoes_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8,	textureof	= 'shoes_1'},
	{label = ('mask_1'),					name = 'mask_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 1},
	{label = ('mask_2'),					name = 'mask_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'mask_1'},
	{label = ('bproof_1'),				    name = 'bproof_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 9},
	{label = ('bproof_2'),				    name = 'bproof_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bproof_1'},
	{label = ('chain_1'),					name = 'chain_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 7},
	{label = ('chain_2'),					name = 'chain_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'chain_1'},
	{label = ('helmet_1'),				    name = 'helmet_1',			value = -1,		min = -1,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 0 },
	{label = ('helmet_2'),				    name = 'helmet_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'helmet_1'},
	{label = ('glasses_1'),				    name = 'glasses_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 1},
	{label = ('glasses_2'),				    name = 'glasses_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'glasses_1'},
	{label = ('watches_1'),				    name = 'watches_1',			value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 6},
	{label = ('watches_2'),				    name = 'watches_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'watches_1'},
	{label = ('bracelets_1'),				name = 'bracelets_1',		value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 7},
	{label = ('bracelets_2'),				name = 'bracelets_2',		value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bracelets_1'},
	{label = ('bag'),						name = 'bags_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 5},
	{label = ('bag_color'),			    	name = 'bags_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bags_1'},
	{label = ('eye_color'),				    name = 'eye_color',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('eye_squint'),				name = 'eye_squint',		value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('eyebrow_size'),			    name = 'eyebrows_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('eyebrow_type'),			    name = 'eyebrows_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('eyebrow_color_1'),			name = 'eyebrows_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('eyebrow_color_2'),			name = 'eyebrows_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('eyebrow_height'),			name = 'eyebrows_5',		value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('eyebrow_depth'),			    name = 'eyebrows_6',		value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('makeup_type'),				name = 'makeup_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('makeup_thickness'),	    	name = 'makeup_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('makeup_color_1'),			name = 'makeup_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('makeup_color_2'),			name = 'makeup_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('lipstick_type'),			    name = 'lipstick_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('lipstick_thickness'),		name = 'lipstick_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('lipstick_color_1'),	    	name = 'lipstick_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('lipstick_color_2'),		    name = 'lipstick_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('ear_accessories'),			name = 'ears_1',			value = -1,		min = -1,	zoomOffset = 0.4,		camOffset = 0.65,	componentId	= 2},
	{label = ('ear_accessories_color'),	    name = 'ears_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65,	textureof	= 'ears_1'},
	{label = ('chest_hair'),				name = 'chest_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = ('chest_hair_1'),			    name = 'chest_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = ('chest_color'),				name = 'chest_3',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = ('bodyb'),					    name = 'bodyb_1',			value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = ('bodyb_size'),				name = 'bodyb_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = ('bodyb_extra'),				name = 'bodyb_3',			value = -1,		min = -1,	zoomOffset = 0.4,		camOffset = 0.15},
	{label = ('bodyb_extra_thickness'),	    name = 'bodyb_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.15},
	{label = ('wrinkles'),				    name = 'age_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('wrinkle_thickness'),		    name = 'age_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('blemishes'),				    name = 'blemishes_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('blemishes_size'),			name = 'blemishes_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('blush'),					    name = 'blush_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('blush_1'),					name = 'blush_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('blush_color'),				name = 'blush_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('complexion'),				name = 'complexion_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('complexion_1'),			    name = 'complexion_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('sun'),						name = 'sun_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('sun_1'),					    name = 'sun_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('freckles'),				    name = 'moles_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('freckles_1'),				name = 'moles_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('beard_type'),				name = 'beard_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('beard_size'),				name = 'beard_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('beard_color_1'),			    name = 'beard_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = ('beard_color_2'),			    name = 'beard_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65}
}

local Character		= {}

for i=1, #Components, 1 do
	Character[Components[i].name] = Components[i].value
end

function GetMaxVals()
	local playerPed = PlayerPedId()

	local data = {
		sex				= 1,
		mom				= 45, -- numbers 21-41 and 45 are female (22 total)
		dad				= 44, -- numbers 0-20 and 42-44 are male (24 total)
		face_md_weight	= 100,
		skin_md_weight	= 100,
		nose_1			= 10,
		nose_2			= 10,
		nose_3			= 10,
		nose_4			= 10,
		nose_5			= 10,
		nose_6			= 10,
		cheeks_1		= 10,
		cheeks_2		= 10,
		cheeks_3		= 10,
		lip_thickness	= 10,
		jaw_1			= 10,
		jaw_2			= 10,
		chin_1			= 10,
		chin_2			= 10,
		chin_3			= 10,
		chin_4			= 10,
		neck_thickness	= 10,
		age_1			= GetNumHeadOverlayValues(3)-1,
		age_2			= 10,
		beard_1			= GetNumHeadOverlayValues(1)-1,
		beard_2			= 10,
		beard_3			= GetNumHairColors()-1,
		beard_4			= GetNumHairColors()-1,
		hair_1			= GetNumberOfPedDrawableVariations(playerPed, 2) - 1,
		hair_2			= GetNumberOfPedTextureVariations(playerPed, 2, Character['hair_1']) - 1,
		hair_color_1	= GetNumHairColors()-1,
		hair_color_2	= GetNumHairColors()-1,
		eye_color		= 31,
		eye_squint		= 10,
		eyebrows_1		= GetNumHeadOverlayValues(2)-1,
		eyebrows_2		= 10,
		eyebrows_3		= GetNumHairColors()-1,
		eyebrows_4		= GetNumHairColors()-1,
		eyebrows_5		= 10,
		eyebrows_6		= 10,
		makeup_1		= GetNumHeadOverlayValues(4)-1,
		makeup_2		= 10,
		makeup_3		= GetNumHairColors()-1,
		makeup_4		= GetNumHairColors()-1,
		lipstick_1		= GetNumHeadOverlayValues(8)-1,
		lipstick_2		= 10,
		lipstick_3		= GetNumHairColors()-1,
		lipstick_4		= GetNumHairColors()-1,
		blemishes_1		= GetNumHeadOverlayValues(0)-1,
		blemishes_2		= 10,
		blush_1			= GetNumHeadOverlayValues(5)-1,
		blush_2			= 10,
		blush_3			= GetNumHairColors()-1,
		complexion_1	= GetNumHeadOverlayValues(6)-1,
		complexion_2	= 10,
		sun_1			= GetNumHeadOverlayValues(7)-1,
		sun_2			= 10,
		moles_1			= GetNumHeadOverlayValues(9)-1,
		moles_2			= 10,
		chest_1			= GetNumHeadOverlayValues(10)-1,
		chest_2			= 10,
		chest_3			= GetNumHairColors()-1,
		bodyb_1			= GetNumHeadOverlayValues(11)-1,
		bodyb_2			= 10,
		bodyb_3			= GetNumHeadOverlayValues(12)-1,
		bodyb_4			= 10,
		ears_1			= GetNumberOfPedPropDrawableVariations(playerPed, 2) - 1,
		ears_2			= GetNumberOfPedPropTextureVariations(playerPed, 2, Character['ears_1'] - 1),
		tshirt_1		= GetNumberOfPedDrawableVariations(playerPed, 8) - 1,
		tshirt_2		= GetNumberOfPedTextureVariations(playerPed, 8, Character['tshirt_1']) - 1,
		torso_1			= GetNumberOfPedDrawableVariations(playerPed, 11) - 1,
		torso_2			= GetNumberOfPedTextureVariations(playerPed, 11, Character['torso_1']) - 1,
		decals_1		= GetNumberOfPedDrawableVariations(playerPed, 10) - 1,
		decals_2		= GetNumberOfPedTextureVariations(playerPed, 10, Character['decals_1']) - 1,
		arms			= GetNumberOfPedDrawableVariations(playerPed, 3) - 1,
		arms_2			= 10,
		pants_1			= GetNumberOfPedDrawableVariations(playerPed, 4) - 1,
		pants_2			= GetNumberOfPedTextureVariations(playerPed, 4, Character['pants_1']) - 1,
		shoes_1			= GetNumberOfPedDrawableVariations(playerPed, 6) - 1,
		shoes_2			= GetNumberOfPedTextureVariations(playerPed, 6, Character['shoes_1']) - 1,
		mask_1			= GetNumberOfPedDrawableVariations(playerPed, 1) - 1,
		mask_2			= GetNumberOfPedTextureVariations(playerPed, 1, Character['mask_1']) - 1,
		bproof_1		= GetNumberOfPedDrawableVariations(playerPed, 9) - 1,
		bproof_2		= GetNumberOfPedTextureVariations(playerPed, 9, Character['bproof_1']) - 1,
		chain_1			= GetNumberOfPedDrawableVariations(playerPed, 7) - 1,
		chain_2			= GetNumberOfPedTextureVariations(playerPed, 7, Character['chain_1']) - 1,
		bags_1			= GetNumberOfPedDrawableVariations(playerPed, 5) - 1,
		bags_2			= GetNumberOfPedTextureVariations(playerPed, 5, Character['bags_1']) - 1,
		helmet_1		= GetNumberOfPedPropDrawableVariations(playerPed, 0) - 1,
		helmet_2		= GetNumberOfPedPropTextureVariations(playerPed, 0, Character['helmet_1']) - 1,
		glasses_1		= GetNumberOfPedPropDrawableVariations(playerPed, 1) - 1,
		glasses_2		= GetNumberOfPedPropTextureVariations(playerPed, 1, Character['glasses_1'] - 1),
		watches_1		= GetNumberOfPedPropDrawableVariations(playerPed, 6) - 1,
		watches_2		= GetNumberOfPedPropTextureVariations(playerPed, 6, Character['watches_1']) - 1,
		bracelets_1		= GetNumberOfPedPropDrawableVariations(playerPed, 7) - 1,
		bracelets_2		= GetNumberOfPedPropTextureVariations(playerPed, 7, Character['bracelets_1'] - 1)
	}
	return data
end