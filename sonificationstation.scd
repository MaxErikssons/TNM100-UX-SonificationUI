(

SynthDef(\sonificationVoice, { arg bus, frequency = 440, frequency1 = 440, frequency2 = 440, soundlevel = 0, wavemix = 0, attack = 0.001, release = 0.5, clip = 1, noiselevel = 0, lfoLevel = 1, lfoFreq = 10, timbreMixLevel = 0, sineLevel = 0, triLevel = 0, squareLevel = 0, sawLevel = 0, whiteNoiseLevel = 0, pinkNoiseLevel = 0, crackleNoiseLevel = 0, t_trig = 0, gate = 0, sustain = 0, lpfCutoff = 2500, bpfCutoff = 2500, hpfCutoff = 2500, mixedSoundLevel = 1, lpfLevel = 0, bpfLevel = 0, hpfLevel = 0, pw = 0.5, lagTime = 0.01, filterLag = 0.01;
	var noise = WhiteNoise.ar(whiteNoiseLevel) + PinkNoise.ar(pinkNoiseLevel) + Dust.ar(440, crackleNoiseLevel);
	var sine0 = SinOsc.ar(frequency);
	var sine1 = SinOsc.ar(frequency1);
	var sine2 = SinOsc.ar(frequency2);
	var sine = (sine0 + sine1 + sine2) / 3;
	var tri0 = LFTri.ar(frequency);
	var tri1 = LFTri.ar(frequency1);
	var tri2 = LFTri.ar(frequency2);
	var tri = (tri0 + tri1 + tri2) / 3;
	var sqr0 = LFPulse.ar(frequency, width: pw);
	var sqr1 = LFPulse.ar(frequency1, width: pw);
	var sqr2 = LFPulse.ar(frequency2, width: pw);
	var sqr = (sqr0 + sqr1 + sqr2) / 3;
	var saw0 = LFSaw.ar(frequency);
	var saw1 = LFSaw.ar(frequency1);
	var saw2 = LFSaw.ar(frequency2);
	var saw = (saw0 + saw1 + saw2) / 3;
	var toneMix = (sine * sineLevel) + (tri * triLevel) + (sqr * squareLevel) + (saw * sawLevel);
	var timbremix = (saw * wavemix) + ((1 - wavemix) * sine);
	var mixed = toneMix + (timbremix * timbreMixLevel);
	var clipped = mixed.clip2(clip) * (2 - clip * (1.5 - clip));
	var mixedSound = clipped + (noise * noiselevel);
	var lowPassFiltered = LPF.ar(mixedSound, lpfCutoff.lag(filterLag));
	var bandPassFiltered = BPF.ar(mixedSound, bpfCutoff.lag(filterLag), 1);
	var highPassFiltered = HPF.ar(mixedSound, hpfCutoff.lag(filterLag));
	var filteredSound = (mixedSound * mixedSoundLevel) + (lowPassFiltered * lpfLevel.lag(lagTime)) + (bandPassFiltered * bpfLevel.lag(lagTime)) + (highPassFiltered * hpfLevel.lag(lagTime));
	var lfo = LFPulse.kr(lfoFreq, width: 0.4).range(lfoLevel, 1);
	var envelope1 = EnvGen.kr(Env.perc(attack, release, 1, -4), t_trig);
	var envelope2 = EnvGen.kr(Env.adsr(attack, 0.5, 1, release, 1, -4), gate);
	var enveloped1 = (filteredSound * envelope1) * lfo;
	var enveloped2 = (filteredSound * envelope2) * lfo;
	var enveloped = (sustain * enveloped2) + ((1 - sustain) * enveloped1);
	var output = enveloped;
	var stereoOut = [output, output] * soundlevel;

	Out.ar(bus, stereoOut);
}).add;

SynthDef(\outputVoice, { arg inputbus, reverbMix = 0.1, reverberation = 0.5, delayTime = 0.33, decay = 0.5, delayLevel = 0;
	var input = In.ar(inputbus, 2);
	var delayed = input + (LocalIn.ar(2) * delayLevel);
	var reverbed = FreeVerb2.ar(delayed[0], delayed[1], reverbMix, reverberation, 0.1, 1);

	LocalOut.ar(DelayL.ar(delayed, 0.5, delayTime)*decay);

	Out.ar(0, reverbed);
}).add;

SynthDef(\sendMouse, {
	SendReply.kr(Impulse.kr(60), '/mousePosition', [MouseX.kr(0,Window.screenBounds.right), MouseY.kr(Window.screenBounds.bottom,0), MouseButton.kr.round], 2323)
}).add;

)

(
var data1 = [4.8, 5.7, 7.7, 5.8, 6.7, 6.4, 7.3, 6.0, 5.5, 3.6, 5.1, 5.5, 5.6, 5.9, 6.8, 5.6, 5.1, 4.9, 4.0, 5.4, 5.3, 5.7, 6.5, 5.9, 4.2, 5.2, 6.6, 5.6, 5.7, 5.2, 5.5, 6.1, 6.1, 5.6, 6.6, 5.0, 4.8, 6.8, 7.1, 6.6, 4.9, 5.5, 4.6, 6.7, 4.5, 5.5, 5.4, 3.2, 6.4, 5.6, 5.1, 3.8, 6.9, 6.5, 6.0, 4.4, 4.9, 4.8, 6.3, 4.9, 5.7, 4.2, 6.8, 6.1, 6.1, 5.2, 6.2, 6.2, 4.1, 6.0, 6.5, 6.3, 5.2, 5.1, 7.1, 5.8, 6.9, 6.5, 6.5, 5.8, 5.8, 6.6, 4.3, 6.5, 5.4, 6.2, 6.6, 5.5, 5.8, 5.2, 6.7, 6.9, 5.8, 6.7, 7.3, 4.5, 5.7, 5.3, 6.1, 5.4, 6.9, 6.8, 5.2, 5.1, 5.9, 6.3, 5.8, 5.8, 5.5, 5.8, 7.6, 5.2, 6.7, 6.5, 8.2, 7.0, 7.1, 7.3, 8.1, 7.2, 4.9, 4.8, 4.6, 7.8, 7.2, 7.0, 6.7, 6.3, 7.1, 8.1, 7.1, 7.0, 5.8, 7.8, 6.4, 6.2, 5.2, 6.5, 5.9, 7.8, 6.6, 7.6, 5.7, 6.1, 6.8, 5.8, 5.8, 7.1, 6.6, 6.5, 5.6, 6.9, 7.6, 7.4, 7.7, 8.5, 6.3, 6.5, 6.0, 6.0, 6.1, 6.1, 7.1, 7.6, 7.4, 4.8, 6.2, 5.0, 7.0, 8.5, 8.4, 7.4, 8.0, 7.1, 7.4, 7.2, 6.5, 7.8, 6.9, 8.3, 8.5, 7.6, 8.1, 7.8, 7.6, 8.0, 8.5, 8.2, 8.5, 7.7, 6.0, 8.5, 7.2, 7.8, 8.8, 8.7, 8.2, 8.0, 8.9, 8.6, 9.8];
var data2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.076492, 0.079005, 0.084885, 0.088337, 0.096258, 0.097175, 0.103193, 0.106328, 0.102333, 0.105995, 0.126754, 0.181060, 0.175086, 0.192159, 0.188051, 0.184955, 0.190028, 0.191519, 0.210595, 0.110901, 0.018423, 0.019830, 0.015163, 0.020875, 0.011728, 0.054806, 0.161188, 0.172952, 0.184450, 0.201427, 0.252323, 0.303659, 0.357944, 0.444403, 0.506947, 0.610716, 0.708581, 0.802197, 0.904437, 1.000939, 1.230341, 1.337886, 1.443976, 1.507685, 1.604603, 1.710847, 1.810457, 1.905972, 2.007809, 2.108840, 2.210180, 2.309122, 2.411864, 2.450764, 2.500845, 2.609632, 2.704385, 2.804983, 2.703913, 2.756943, 2.749949, 2.759243, 2.765760, 2.769914, 2.909337, 2.952995, 3.005412, 3.159496, 3.354391, 3.506507, 3.553540, 3.415310, 3.386370, 3.510872, 3.527619, 3.554374, 3.570191, 3.570417, 3.602943, 3.653106, 3.757291, 3.832005, 3.903441, 4.005438, 4.101041, 4.204473, 4.310312, 4.372367, 4.425603, 4.559353, 4.643761, 4.711494, 4.784990, 4.842295, 4.882203, 4.915204, 4.955076, 5.000810, 5.051542, 5.103395, 5.111341];

var data = data1;

var pitchFlag = false;
var pitchInvFlag = false;
var pitchQuantFlag = false;
var amplitudeFlag = false;
var amplitudeInvFlag = false;
var amplitudeSusFlag = false;
var amplitudeModFlag = false;
var amplitudeModInvFlag = false;
var wavemixFlag = false;
var wavemixInvFlag = false;
var attackFlag = false;
var attackInvFlag = false;
var releaseFlag = false;
var releaseInvFlag = false;
var clipFlag = false;
var clipInvFlag = false;
var noiseFlag = false;
var noiseType = 0;
var waveForm = 0;
var lpfFlag = false;
var lpfInvFlag = false;
var bpfFlag = false;
var bpfInvFlag = false;
var hpfFlag = false;
var hpfInvFlag = false;
var harmonyFlag = false;
var harmonyInvFlag = false;
var chordFlag = false;
var chordInvFlag = false;
var reverbFlag = false;
var reverbInvFlag = false;
var delayFlag = false;
var delayInvFlag = false;
var pwFlag = false;
var pwInvFlag = false;
var data1Flag = true;
var data2Flag = false;
var data2SonFlag = false;

~windowWidth = Window.screenBounds.right;
~windowHeight = Window.screenBounds.bottom;

// C, Eb, F, G, bb
~originalTones = [12, 15, 17, 19, 22];
~quantTones = ~originalTones;
for (0, 7) { arg index;
	~originalTones = ~originalTones + 12;
	~quantTones = ~quantTones.addAll(~originalTones);
};



w = Window.new("Sonifiering",
	Rect.new(
		0,
		0,
		~windowWidth,
		~windowHeight))
.front
.alwaysOnTop_(false)
.fullScreen
.background_(Color.new255(50, 50, 50, 255));

~graphType = 0;
~margin = (w.bounds.width * 0.8) * 0.05;
~headingSize = (~margin / 5);
~textSize = (~headingSize * 0.8);
~buttonMarginTop = (~margin / 3);
~buttonMarginLeft = (~margin / 6);
~buttonWidth = ~margin;
~buttonHeight = (~buttonWidth / 5);

~graphView = UserView(w, Rect(0, (w.bounds.height * 0.2), (w.bounds.width * 0.8), (w.bounds.height * 0.8)))
.drawFunc = {
	var grey = 200;
	~xStepSize = (~graphView.bounds.width - ~margin) / (data.size + 1);
	~yStepSize = (~graphView.bounds.height - (~margin * 2)) / ~maxOfArray.value(data1);

	//draw axis
	Pen.width = 1;
	Pen.line(~margin@~margin, ~margin@(~graphView.bounds.height - ~margin));
	Pen.line(~margin@(~graphView.bounds.height - ~margin), (~margin + (~xStepSize * data.size))@(~graphView.bounds.height - ~margin));
	Pen.stroke;

	//draw y
	for (0, ((~graphView.bounds.height - (~margin * 2)) / ~yStepSize), { arg i;
		if (i < ((~graphView.bounds.height - (~margin * 2)) / ~yStepSize)) {
			Pen.strokeColor = Color.new255(grey,grey,grey, 200);
			Pen.line((~margin)@(~margin + (~yStepSize * i)), (~margin + (~xStepSize * data.size))@(~margin + (~yStepSize * i)));
			Pen.stroke;
		};
		Pen.strokeColor = Color.new255(0,0,0, 255);
		Pen.line((~margin - 5)@(~margin + (~yStepSize * i)), (~margin + 5)@(~margin + (~yStepSize * i)));
		Pen.stroke;
		Pen.font = Font("Arial", ~textSize * 2);
		Pen.stringAtPoint((10 - i).asString, (~margin / 2)@(~margin + (~yStepSize * i) - (~yStepSize / 6)));
	});

	for (1, data.size, { arg i;
		Pen.strokeColor = Color.new255(grey,grey,grey, 155);
		Pen.line((~margin + (~xStepSize * i))@(~graphView.bounds.height - ~margin), (~margin + (~xStepSize * i))@(~margin));
		Pen.stroke;
	});

	switch (~graphType,
		0,   {
			//draw x
			for (0, (data.size - 1), { arg i;
				Pen.strokeColor = Color.new255(0,0,0, 255);
				Pen.line((~margin + (~xStepSize * i))@(~graphView.bounds.height - ~margin - 5), (~margin + (~xStepSize * i))@(~graphView.bounds.height - ~margin + 5));
				Pen.stroke;
				if ((i == 0) || (i % 20 == 0)) {
					Pen.font = Font("Arial", ~textSize * 1.5);
					Pen.stringAtPoint((1820 + i).asString, (~margin + (~xStepSize * i) - (~textSize * 2))@(~graphView.bounds.height - ~margin + ~textSize));
				}
			});
			~lineGraph.value;
		},
		1, {
			for (0, (data.size - 1), { arg i;
				Pen.strokeColor = Color.new255(0,0,0, 255);
				Pen.line((~margin + (~xStepSize * i + (~xStepSize / 2)))@(~graphView.bounds.height - ~margin - 5), (~margin + (~xStepSize * i + (~xStepSize / 2)))@(~graphView.bounds.height - ~margin + 5));
				Pen.stroke;
				if ((i == 0) || (i % 20 == 0)) {
					Pen.font = Font("Arial", ~textSize * 1.5);
					Pen.stringAtPoint((1820 + i).asString, (~margin + (~xStepSize * i) - (~textSize * 2))@(~graphView.bounds.height - ~margin + ~textSize));
				};
			});
			~barGraph.value;

		},
	);
};
~graphView.background = Color.white;
~graphHeight = ~graphView.bounds.height;
~graphWidth = ~graphView.bounds.width;

~markerSize = ~graphView.bounds.width * 0.025;
~markerColor = Color.new255(0,100,0, 200);
~markerView = UserView(~graphView, Rect(0, 0, ~markerSize, ~markerSize))
.drawFunc = {
	Pen.width = 2;
	Pen.strokeColor = ~markerColor;
	Pen.strokeOval(Rect.aboutPoint(Point((~markerSize / 2), (~markerSize / 2)), (~markerSize / 3), (~markerSize / 3)));
};
~markerView.visible_(false);



~visSelectView = UserView(w, Rect(0, 0, (w.bounds.width * 0.8), (w.bounds.height * 0.2)))
.background_(Color.new255(255,255,255, 25));
~visHeading = StaticText.new(~visSelectView, Rect(~buttonMarginLeft, 0, ~visSelectView.bounds.width, (~visSelectView.bounds.height / 2)))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Utforska sonifiering")
.align_(\left)
.font_(Font("Arial", ~headingSize * 4))
.visible_(true);
~introText = StaticText.new(~visSelectView, Rect(~buttonMarginLeft, (~buttonMarginTop * 3.25), ~visSelectView.bounds.width, (~visSelectView.bounds.height / 2)))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Sonifiering innebär att datavärden kopplas till ljud och när datavärdena förändras, förändras också ljudet. Det innebär att ljudet
kan användas som en ljudversion av visualisering, och hjälpa till att förtydliga och förenkla förståelsen av förändringar i data.

Nedan visas data över temperaturmätningar från Stockholm, årliga medeltemperaturer från 1820 och fram till 2020, eller
data över registrerade fordon i Sveriga från 1920 till 2020.")
.align_(\left)
.font_(Font("Arial", ~headingSize))
.visible_(true);
~lineSelect  = CheckBox.new(~visSelectView, Rect(~buttonMarginLeft, (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.value_(true)
.action_({
})
.string_("");
~lineText = StaticText.new(~visSelectView, Rect((~buttonMarginLeft + ~buttonHeight),  (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonWidth, ~buttonHeight))
.string_("Linjediagram")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~vis1 = Button.new(~visSelectView, Rect(~buttonMarginLeft,  (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	~graphType = 0;
	~lineSelect.value_(true);
	~barSelect.value_(false);
	~graphView.refresh;
});
~barSelect  = CheckBox.new(~visSelectView, Rect((~buttonMarginLeft * 8), (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~barText = StaticText.new(~visSelectView, Rect((~buttonMarginLeft *8 + ~buttonHeight),  (~visSelectView.bounds.height - ~buttonMarginTop), (~buttonWidth + 10), ~buttonHeight))
.string_("Stapeldiagram")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~vis2 = Button.new(~visSelectView, Rect((~buttonMarginLeft *8),  (~visSelectView.bounds.height - ~buttonMarginTop), (~buttonWidth + 10), ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	~graphType = 1;
	~barSelect.value_(true);
	~lineSelect.value_(false);
	~graphView.refresh;
});
~dataText = StaticText.new(~visSelectView, Rect(((~buttonMarginLeft * 16) + ~buttonHeight),  (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonWidth, ~buttonHeight))
.string_("Visualisera:")
.align_(\right)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~data1Select  = CheckBox.new(~visSelectView, Rect((~buttonMarginLeft * 24), (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.value_(true)
.action_({
})
.string_("");
~data1Text = StaticText.new(~visSelectView, Rect(((~buttonMarginLeft * 24) + ~buttonHeight),  (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonWidth, ~buttonHeight))
.string_("Temperaturdata")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~data1 = Button.new(~visSelectView, Rect((~buttonMarginLeft * 24),  (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (~data1Select.value) {
		data1Flag = false;
		~data1Select.value_(false);
	} {
		data1Flag = true;
		~data1Select.value_(true);
	};
	~graphView.refresh;
});
~data2Select  = CheckBox.new(~visSelectView, Rect((~buttonMarginLeft * 32), (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~data2Text = StaticText.new(~visSelectView, Rect((~buttonMarginLeft * 32 + ~buttonHeight),  (~visSelectView.bounds.height - ~buttonMarginTop), (~buttonWidth + 10), ~buttonHeight))
.string_("Fordonsdata")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~data2 = Button.new(~visSelectView, Rect((~buttonMarginLeft * 32),  (~visSelectView.bounds.height - ~buttonMarginTop), (~buttonWidth + 10), ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (~data2Select.value) {
		data2Flag = false;
		~data2Select.value_(false);
		data1Flag = true;
		~data1Select.value_(true);
	} {
		data2Flag = true;
		~data2Select.value_(true);
	};
	~graphView.refresh;
});
~sonText = StaticText.new(~visSelectView, Rect(((~buttonMarginLeft * 40) + ~buttonHeight),  (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonWidth, ~buttonHeight))
.string_("Sonifiera:")
.align_(\right)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~son1Select  = CheckBox.new(~visSelectView, Rect((~buttonMarginLeft * 48), (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.value_(true)
.action_({
})
.string_("");
~son1Text = StaticText.new(~visSelectView, Rect(((~buttonMarginLeft * 48) + ~buttonHeight),  (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonWidth, ~buttonHeight))
.string_("Temperaturdata")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~son1 = Button.new(~visSelectView, Rect((~buttonMarginLeft * 48),  (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (~son1Select.value) {

	} {
		data = data1;
		data2SonFlag = false;
		~son1Select.value_(true);
		~son2Select.value_(false);
		~markerColor = Color.new255(0,100,0, 200);
	};
	~graphView.refresh;
});
~son2Select  = CheckBox.new(~visSelectView, Rect((~buttonMarginLeft * 56), (~visSelectView.bounds.height - ~buttonMarginTop), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~son2Text = StaticText.new(~visSelectView, Rect((~buttonMarginLeft * 56 + ~buttonHeight),  (~visSelectView.bounds.height - ~buttonMarginTop), (~buttonWidth + 10), ~buttonHeight))
.string_("Fordonsdata")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~son2 = Button.new(~visSelectView, Rect((~buttonMarginLeft * 56),  (~visSelectView.bounds.height - ~buttonMarginTop), (~buttonWidth + 10), ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (~son2Select.value) {
		data = data1;
		data2SonFlag = false;
		~son2Select.value_(false);
		~son1Select.value_(true);
		~markerColor = Color.new255(0,100,0, 200);
	} {
		data = data2;
		data2SonFlag = true;
		~son2Select.value_(true);
		~son1Select.value_(false);
		~markerColor = Color.new255(0,0,200, 200);
	};
	~graphView.refresh;
});








~infoText = StaticText.new(w, Rect((~visSelectView.bounds.width + ~margin), ~buttonMarginTop * 5, ~buttonWidth * 3, ~buttonHeight * 8))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Ställ in ljudet
här nedan:")
.align_(\left)
.font_(Font("Arial", ~headingSize * 1.5))
.visible_(true);



// -----------
// Wave forms
// -----------
~waveGroup = UserView(w, Rect((~graphWidth + ~margin), (w.bounds.height * 0.2),  (~margin * 3), ~margin))
.background_(Color.new255(43, 166, 88, 100));
~waveHeading = StaticText.new(~waveGroup, Rect((~buttonMarginLeft / 3), (~buttonMarginLeft / 3), ~buttonWidth, ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Vågform")
.align_(\left)
.font_(Font("Arial", ~headingSize))
.visible_(true);
~sineSelect  = CheckBox.new(~waveGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~sineText = StaticText.new(~waveGroup, Rect((~buttonMarginLeft + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Sinus")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~wave1 = Button.new(~waveGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (waveForm == 1) {
		waveForm = 0;
		~sineSelect.value_(false);
		~oldWave = 0;
	} {
		waveForm = 1;
		~sineSelect.value_(true);
		~triSelect.value_(false);
		~squareSelect.value_(false);
		~sawSelect.value_(false);
		~oldWave = 1;
	};
});
~triSelect  = CheckBox.new(~waveGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~triText = StaticText.new(~waveGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Triangel")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~wave2 = Button.new(~waveGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (waveForm == 2) {
		waveForm = 0;
		~triSelect.value_(false);
		~oldWave = 0;
	} {
		waveForm = 2;
		~sineSelect.value_(false);
		~triSelect.value_(true);
		~squareSelect.value_(false);
		~sawSelect.value_(false);
		~oldWave = 2;
	};
});
~squareSelect  = CheckBox.new(~waveGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~squareText = StaticText.new(~waveGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Fyrkant")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~wave3 = Button.new(~waveGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (waveForm == 3) {
		waveForm = 0;
		~squareSelect.value_(false);
		~oldWave = 0;
	} {
		waveForm = 3;
		~sineSelect.value_(false);
		~triSelect.value_(false);
		~squareSelect.value_(true);
		~sawSelect.value_(false);
		~oldWave = 3;
	};
});
~sawSelect  = CheckBox.new(~waveGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~sawText = StaticText.new(~waveGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Sågtand")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~wave4 = Button.new(~waveGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (waveForm == 4) {
		waveForm = 0;
		~sawSelect.value_(false);
		~oldWave = 0;
	} {
		waveForm = 4;
		~sineSelect.value_(false);
		~triSelect.value_(false);
		~squareSelect.value_(false);
		~sawSelect.value_(true);
		~oldWave = 4;
	};
});





// -----------
// Pitch
// -----------
~pitchGroup = UserView(w, Rect((~graphWidth + ~margin), (w.bounds.height * 0.2  + (~margin * 1.1)),  (~margin * 3), ~margin))
.background_(Color.new255(43, 166, 123, 100));
~pitchHeading = StaticText.new(~pitchGroup, Rect((~buttonMarginLeft / 3), (~buttonMarginLeft / 3), ~buttonWidth, ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Tonhöjd")
.align_(\left)
.font_(Font("Arial", ~headingSize))
.visible_(true);
~pitchSelect  = CheckBox.new(~pitchGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({

})
.string_("");
~pitchText = StaticText.new(~pitchGroup, Rect((~buttonMarginLeft + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Frekvens")
.align_(\left)
.font_(Font("Arial", ~textSize))
.visible_(true);
~pitchb1 = Button.new(~pitchGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (pitchFlag) {
		pitchFlag = false;
		pitchInvFlag = false;
		~pitchSelect.value_(false);
		~pitchInvSelect.value_(false);
		~pitchb2.enabled_(false);
		~pitchInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		pitchFlag = true;
		pitchQuantFlag = false;
		~pitchSelect.value_(true);
		~pitchQuantSelect.value_(false);
		~pitchb2.enabled_(true);
		~pitchInvText.stringColor_(Color.new255(255,255,255, 255));
	};
});
~pitchInvSelect  = CheckBox.new(~pitchGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~pitchInvText = StaticText.new(~pitchGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~pitchb2 = Button.new(~pitchGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (pitchInvFlag) {
		pitchInvFlag = false;
		~pitchInvSelect.value_(false);
	} {
		pitchInvFlag = true;
		~pitchInvSelect.value_(true);
	};
});
~pitchQuantSelect  = CheckBox.new(~pitchGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~pitchQuantText = StaticText.new(~pitchGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Toner")
.align_(\left)
.font_(Font("Arial", ~textSize))
.visible_(true);
~pitchb3 = Button.new(~pitchGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (pitchQuantFlag) {
		pitchQuantFlag = false;
		pitchInvFlag = false;
		~pitchQuantSelect.value_(false);
		~pitchInvSelect.value_(false);
		~pitchInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		pitchQuantFlag = true;
		pitchFlag = false;
		~pitchQuantSelect.value_(true);
		~pitchSelect.value_(false);
		~pitchb2.enabled_(true);
		~pitchInvText.stringColor_(Color.new255(255,255,255, 255));
	};
});



// -----------
// Harmony
// -----------
~harmonyGroup = UserView(w, Rect((~graphWidth + ~margin), (w.bounds.height * 0.2  + (~margin * 2.2)),  (~margin * 3), ~margin))
.background_(Color.new255(43, 150, 166, 100));
~pitchHeading = StaticText.new(~harmonyGroup, Rect((~buttonMarginLeft / 3), (~buttonMarginLeft / 3), ~buttonWidth, ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Harmoni")
.align_(\left)
.font_(Font("Arial", ~headingSize))
.visible_(true);
~harmonySelect  = CheckBox.new(~harmonyGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({

})
.string_("");
~harmonyText = StaticText.new(~harmonyGroup, Rect((~buttonMarginLeft + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Harmoni")
.align_(\left)
.font_(Font("Arial", ~textSize))
.visible_(true);
~harmony1 = Button.new(~harmonyGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (harmonyFlag) {
		harmonyFlag = false;
		harmonyInvFlag = false;
		~harmonySelect.value_(false);
		~harmonyInvSelect.value_(false);
		~harmony2.enabled_(false);
		~harmonyInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		harmonyFlag = true;
		chordFlag = false;
		chordInvFlag = false;
		~harmonySelect.value_(true);
		~harmony2.enabled_(true);
		~harmonyInvText.stringColor_(Color.new255(255,255,255, 255));
		~chordSelect.value_(false);
		~chordInvSelect.value_(false);
		~chordInvText.stringColor_(Color.new255(255,255,255, 100));
	};
});
~harmonyInvSelect  = CheckBox.new(~harmonyGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~harmonyInvText = StaticText.new(~harmonyGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~harmony2 = Button.new(~harmonyGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (harmonyInvFlag) {
		harmonyInvFlag = false;
		~harmonyInvSelect.value_(false);
	} {
		harmonyInvFlag = true;
		~harmonyInvSelect.value_(true);
	};
});
~chordSelect  = CheckBox.new(~harmonyGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~chordText = StaticText.new(~harmonyGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Dur & moll")
.align_(\left)
.font_(Font("Arial", ~textSize))
.visible_(true);
~harmony3 = Button.new(~harmonyGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (chordFlag) {
		chordFlag = false;
		chordInvFlag = false;
		~chordSelect.value_(false);
		~chordInvSelect.value_(false);
		~harmony4.enabled_(false);
		~chordInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		chordFlag = true;
		harmonyFlag = false;
		harmonyInvFlag = false;
		~chordSelect.value_(true);
		~harmonySelect.value_(false);
		~harmony4.enabled_(true);
		~chordInvText.stringColor_(Color.new255(255,255,255, 255));
		~harmonySelect.value_(false);
		~harmonyInvSelect.value_(false);
		~harmonyInvText.stringColor_(Color.new255(255,255,255, 100));
	};
});
~chordInvSelect  = CheckBox.new(~harmonyGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~chordInvText = StaticText.new(~harmonyGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~harmony4 = Button.new(~harmonyGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (chordInvFlag) {
		chordInvFlag = false;
		~chordInvSelect.value_(false);
	} {
		chordInvFlag = true;
		~chordInvSelect.value_(true);
	};
});




// -----------
// Timbre
// -----------
~timbreGroup = UserView(w, Rect((~graphWidth + ~margin), (w.bounds.height * 0.2 + (~margin * 3.3)), (~margin * 3), (~margin * 1.33)))
.background_(Color.new255(44, 142, 191, 100));
~timbreHeading = StaticText.new(~timbreGroup, Rect((~buttonMarginLeft / 3), (~buttonMarginLeft / 3), ~buttonWidth, ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Klangfärg")
.align_(\left)
.font_(Font("Arial", ~headingSize))
.visible_(true);
~wavemixSelect  = CheckBox.new(~timbreGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~wavemixText = StaticText.new(~timbreGroup, Rect((~buttonMarginLeft + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Vågform")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~timbre1 = Button.new(~timbreGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (wavemixFlag) {
		wavemixFlag = false;
		wavemixInvFlag = false;
		~wavemixSelect.value_(false);
		~wavemixInvSelect.value_(false);
		~timbre2.enabled_(false);
		~wavemixInvText.stringColor_(Color.new255(255,255,255, 100));
		~sineText.stringColor_(Color.new255(255,255,255, 255));
		~triText.stringColor_(Color.new255(255,255,255, 255));
		~squareText.stringColor_(Color.new255(255,255,255, 255));
		~sawText.stringColor_(Color.new255(255,255,255, 255));
		switch (~oldWave,
			0, { ~sineSelect.value_(false); ~triSelect.value_(false); ~squareSelect.value_(false); ~sawSelect.value_(false); },
			1, { ~sineSelect.value_(true); ~triSelect.value_(false); ~squareSelect.value_(false); ~sawSelect.value_(false); },
			2, { ~sineSelect.value_(false); ~triSelect.value_(true); ~squareSelect.value_(false); ~sawSelect.value_(false); },
			3, { ~sineSelect.value_(true); ~triSelect.value_(false); ~squareSelect.value_(true); ~sawSelect.value_(false); },
			4, { ~sineSelect.value_(false); ~triSelect.value_(false); ~squareSelect.value_(false);~sawSelect.value_(true); }
		);
	} {
		wavemixFlag = true;
		~wavemixSelect.value_(true);
		~timbre2.enabled_(true);
		~wavemixInvText.stringColor_(Color.new255(255,255,255, 255));
		~sineText.stringColor_(Color.new255(255,255,255, 100));
		~triText.stringColor_(Color.new255(255,255,255, 100));
		~squareText.stringColor_(Color.new255(255,255,255, 100));
		~sawText.stringColor_(Color.new255(255,255,255, 100));
		~sineSelect.value_(true);
		~triSelect.value_(false);
		~squareSelect.value_(false);
		~sawSelect.value_(true);
	};
});
~wavemixInvSelect  = CheckBox.new(~timbreGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~wavemixInvText = StaticText.new(~timbreGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~timbre2 = Button.new(~timbreGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (wavemixInvFlag) {
		wavemixInvFlag = false;
		~wavemixInvSelect.value_(false);
	} {
		wavemixInvFlag = true;
		~wavemixInvSelect.value_(true);
	};
});


~pwSelect  = CheckBox.new(~timbreGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~pwText = StaticText.new(~timbreGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Pulsbredd")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~timbre3 = Button.new(~timbreGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (pwFlag) {
		pwFlag = false;
		pwInvFlag = false;
		~pwSelect.value_(false);
		~pwInvSelect.value_(false);
		~timbre4.enabled_(false);
		~pwInvText.stringColor_(Color.new255(255,255,255, 100));
		~sineText.stringColor_(Color.new255(255,255,255, 255));
		~triText.stringColor_(Color.new255(255,255,255, 255));
		~squareText.stringColor_(Color.new255(255,255,255, 255));
		~sawText.stringColor_(Color.new255(255,255,255, 255));
		switch (~oldWave,
			0, { ~sineSelect.value_(false); ~triSelect.value_(false); ~squareSelect.value_(false); ~sawSelect.value_(false); },
			1, { ~sineSelect.value_(true); ~triSelect.value_(false); ~squareSelect.value_(false); ~sawSelect.value_(false); },
			2, { ~sineSelect.value_(false); ~triSelect.value_(true); ~squareSelect.value_(false); ~sawSelect.value_(false); },
			3, { ~sineSelect.value_(true); ~triSelect.value_(false); ~squareSelect.value_(true); ~sawSelect.value_(false); },
			4, { ~sineSelect.value_(false); ~triSelect.value_(false); ~squareSelect.value_(false);~sawSelect.value_(true); }
		);
	} {
		pwFlag = true;
		~pwSelect.value_(true);
		~timbre4.enabled_(true);
		~pwInvText.stringColor_(Color.new255(255,255,255, 255));
		~sineText.stringColor_(Color.new255(255,255,255, 100));
		~triText.stringColor_(Color.new255(255,255,255, 100));
		~squareText.stringColor_(Color.new255(255,255,255, 100));
		~sawText.stringColor_(Color.new255(255,255,255, 100));
		~sineSelect.value_(false);
		~triSelect.value_(false);
		~squareSelect.value_(true);
		~sawSelect.value_(false);
	};
});
~pwInvSelect  = CheckBox.new(~timbreGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~pwInvText = StaticText.new(~timbreGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~timbre4 = Button.new(~timbreGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (pwInvFlag) {
		pwInvFlag = false;
		~pwInvSelect.value_(false);
	} {
		pwInvFlag = true;
		~pwInvSelect.value_(true);
	};
});


~clipSelect  = CheckBox.new(~timbreGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 3), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~clipText = StaticText.new(~timbreGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 3), ~buttonWidth, ~buttonHeight))
.string_("Distortion")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~timbre5 = Button.new(~timbreGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 3), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (clipFlag) {
		clipFlag = false;
		clipInvFlag = false;
		~clipSelect.value_(false);
		~clipInvSelect.value_(false);
		~timbre6.enabled_(false);
		~clipInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		clipFlag = true;
		~clipSelect.value_(true);
		~timbre6.enabled_(true);
		~clipInvText.stringColor_(Color.new255(255,255,255, 255));
	};
});
~clipInvSelect  = CheckBox.new(~timbreGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 3), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~clipInvText = StaticText.new(~timbreGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), (~buttonMarginTop * 3), ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~timbre6 = Button.new(~timbreGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 3), ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (clipInvFlag) {
		clipInvFlag = false;
		~clipInvSelect.value_(false);
	} {
		clipInvFlag = true;
		~clipInvSelect.value_(true);
	};
});




// -----------
// Noise
// -----------
~noiseGroup = UserView(w, Rect((~graphWidth + ~margin), (w.bounds.height * 0.2 + (~margin * 4.73)),  (~margin * 3), ~margin))
.background_(Color.new255(38, 81, 145, 100));
~noiseHeading = StaticText.new(~noiseGroup, Rect((~buttonMarginLeft / 3), (~buttonMarginLeft / 3), ~buttonWidth, ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Brus")
.align_(\left)
.font_(Font("Arial", ~headingSize))
.visible_(true);
~whiteNoiseSelect = CheckBox.new(~noiseGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~whiteNoiseText = StaticText.new(~noiseGroup, Rect((~buttonMarginLeft + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Vitt brus")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~noise1 = Button.new(~noiseGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (noiseType == 1) {
		noiseFlag = false;
		noiseType = 0;
		~whiteNoiseSelect.value_(false);
		~noiseVis.background_(Color.new255(224, 224, 224, 100));
	} {
		noiseFlag = true;
		noiseType = 1;
		~whiteNoiseSelect.value_(true);
		~pinkNoiseSelect.value_(false);
		~crackleNoiseSelect.value_(false);
		~noiseVis.background_(Color.new255(224, 224, 224, 255));
	};
});
~pinkNoiseSelect  = CheckBox.new(~noiseGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~pinkNoiseText = StaticText.new(~noiseGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Rosa brus")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~noise2 = Button.new(~noiseGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (noiseType == 2) {
		noiseFlag = false;
		noiseType = 0;
		~pinkNoiseSelect.value_(false);
		~crackleNoiseSelect.value_(false);
		~noiseVis.background_(Color.new255(208, 126, 217, 100));
	} {
		noiseFlag = true;
		noiseType = 2;
		~pinkNoiseSelect.value_(true);
		~whiteNoiseSelect.value_(false);
		~crackleNoiseSelect.value_(false);
		~noiseVis.background_(Color.new255(208, 126, 217, 255));
	};
});
~crackleNoiseSelect  = CheckBox.new(~noiseGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~crackleNoiseText = StaticText.new(~noiseGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Knaster")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~noise3 = Button.new(~noiseGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (noiseType == 3) {
		noiseFlag = false;
		noiseType = 0;
		~crackleNoiseSelect.value_(false);
		~noiseVis.background_(Color.new255(94, 166, 224, 100));
	} {
		noiseFlag = true;
		noiseType = 3;
		~crackleNoiseSelect.value_(true);
		~pinkNoiseSelect.value_(false);
		~whiteNoiseSelect.value_(false);
		~noiseVis.background_(Color.new255(94, 166, 224, 255));
	};
});
~noiseVis = UserView(~noiseGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.background_(Color.new255(224, 224, 224, 100));




// -----------
// Filter
// -----------
~oldFilter = "";
~currentFilter = "";
~lagTime = 0.01;
~filterGroup = UserView(w, Rect((~graphWidth + ~margin), (w.bounds.height * 0.2 + (~margin * 5.82)),  (~margin * 3), (~margin * 1.33)))
.background_(Color.new255(106, 38, 145, 100));
~filterHeading = StaticText.new(~filterGroup, Rect((~buttonMarginLeft / 3), (~buttonMarginLeft / 3), (~buttonWidth * 2), ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Filter")
.align_(\left)
.font_(Font("Arial", ~headingSize))
.visible_(true);
~lpfSelect  = CheckBox.new(~filterGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~lpfText = StaticText.new(~filterGroup, Rect((~buttonMarginLeft + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Lågpass")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~filter1 = Button.new(~filterGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (lpfFlag) {
		lpfFlag = false;
		lpfInvFlag = false;
		~lpfSelect.value_(false);
		~lpfInvSelect.value_(false);
		~filter2.enabled_(false);
		~lpfInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		~currentFilter = "lpf";
		lpfFlag = true;
		bpfFlag = false;
		hpfFlag = false;
		~lpfSelect.value_(true);
		~bpfSelect.value_(false);
		~hpfSelect.value_(false);
		~filter2.enabled_(true);
		~lpfInvText.stringColor_(Color.new255(255,255,255, 255));
		~filter4.enabled_(false);
		~bpfInvText.stringColor_(Color.new255(255,255,255, 100));
		~filter6.enabled_(false);
		~hpfInvText.stringColor_(Color.new255(255,255,255, 100));
		~bpfInvSelect.value_(false);
		~hpfInvSelect.value_(false);
	};
});
~lpfInvSelect  = CheckBox.new(~filterGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~lpfInvText = StaticText.new(~filterGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~filter2 = Button.new(~filterGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (lpfInvFlag) {
		lpfInvFlag = false;
		~lpfInvSelect.value_(false);
	} {
		lpfInvFlag = true;
		~lpfInvSelect.value_(true);
	};
});
~bpfSelect  = CheckBox.new(~filterGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~bpfText = StaticText.new(~filterGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Bandpass")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~filter3 = Button.new(~filterGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (bpfFlag) {
		bpfFlag = false;
		bpfInvFlag = false;
		~bpfSelect.value_(false);
		~bpfInvSelect.value_(false);
		~filter4.enabled_(false);
		~bpfInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		~currentFilter = "bpf";
		lpfFlag = false;
		bpfFlag = true;
		hpfFlag = false;
		~lpfSelect.value_(false);
		~bpfSelect.value_(true);
		~hpfSelect.value_(false);
		~filter2.enabled_(false);
		~lpfInvText.stringColor_(Color.new255(255,255,255, 100));
		~filter4.enabled_(true);
		~bpfInvText.stringColor_(Color.new255(255,255,255, 255));
		~filter6.enabled_(false);
		~hpfInvText.stringColor_(Color.new255(255,255,255, 100));
		~lpfInvSelect.value_(false);
		~hpfInvSelect.value_(false);
	};
});
~bpfInvSelect  = CheckBox.new(~filterGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~bpfInvText = StaticText.new(~filterGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~filter4 = Button.new(~filterGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (bpfInvFlag) {
		bpfInvFlag = false;
		~bpfInvSelect.value_(false);
	} {
		bpfInvFlag = true;
		~bpfInvSelect.value_(true);
	};
});
~hpfSelect  = CheckBox.new(~filterGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 3), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~hpfText = StaticText.new(~filterGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 3), ~buttonWidth, ~buttonHeight))
.string_("Högpass")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~filter5 = Button.new(~filterGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 3), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (hpfFlag) {
		hpfFlag = false;
		hpfInvFlag = false;
		~hpfSelect.value_(false);
		~hpfInvSelect.value_(false);
		~filter6.enabled_(false);
		~hpfInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		~currentFilter = "hpf";
		lpfFlag = false;
		bpfFlag = false;
		hpfFlag = true;
		~lpfSelect.value_(false);
		~bpfSelect.value_(false);
		~hpfSelect.value_(true);
		~filter2.enabled_(false);
		~lpfInvText.stringColor_(Color.new255(255,255,255, 100));
		~filter4.enabled_(false);
		~bpfInvText.stringColor_(Color.new255(255,255,255, 100));
		~filter6.enabled_(true);
		~hpfInvText.stringColor_(Color.new255(255,255,255, 255));
		~lpfInvSelect.value_(false);
		~bpfInvSelect.value_(false);
	};
});
~hpfInvSelect  = CheckBox.new(~filterGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 3), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~hpfInvText = StaticText.new(~filterGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), (~buttonMarginTop * 3), ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~filter6 = Button.new(~filterGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 3), ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (hpfInvFlag) {
		hpfInvFlag = false;
		~hpfInvSelect.value_(false);
	} {
		hpfInvFlag = true;
		~hpfInvSelect.value_(true);
	};
});





// -----------
// Amplitude
// -----------
~amplitudeGroup = UserView(w, Rect((~graphWidth + ~margin), (w.bounds.height * 0.2 + (~margin * 7.25)),  (~margin * 3), (~margin * 1.33)))
.background_(Color.new255(141, 38, 145, 100));
~amplitudeHeading = StaticText.new(~amplitudeGroup, Rect((~buttonMarginLeft / 3), (~buttonMarginLeft / 3), ~buttonWidth, ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Ljudvolym")
.align_(\left)
.font_(Font("Arial", ~headingSize))
.visible_(true);
~amplitudeSelect  = CheckBox.new(~amplitudeGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~amplitudeText = StaticText.new(~amplitudeGroup, Rect((~buttonMarginLeft + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Ljudvolum")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~amplitude1 = Button.new(~amplitudeGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (amplitudeFlag) {
		amplitudeFlag = false;
		amplitudeInvFlag = false;
		~amplitudeSelect.value_(false);
		~amplitudeInvSelect.value_(false);
		~amplitude2.enabled_(false);
		~amplitudeInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		amplitudeFlag = true;
		~amplitudeSelect.value_(true);
		~amplitude2.enabled_(true);
		~amplitudeInvText.stringColor_(Color.new255(255,255,255, 255));
	};
});
~amplitudeInvSelect  = CheckBox.new(~amplitudeGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~amplitudeInvText = StaticText.new(~amplitudeGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~amplitude2 = Button.new(~amplitudeGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (amplitudeInvFlag) {
		amplitudeInvFlag = false;
		~amplitudeInvSelect.value_(false);
	} {
		amplitudeInvFlag = true;
		~amplitudeInvSelect.value_(true);
	};
});
~amplitudeModSelect  = CheckBox.new(~amplitudeGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~amplitudeModText = StaticText.new(~amplitudeGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Modulation")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~amplitude3 = Button.new(~amplitudeGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (amplitudeModFlag) {
		amplitudeModFlag = false;
		~amplitudeModSelect.value_(false);
		~amplitudeModInvSelect.value_(false);
		~amplitude4.enabled_(false);
		~amplitudeModInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		amplitudeModFlag = true;
		~amplitudeModSelect.value_(true);
		~amplitude4.enabled_(true);
		~amplitudeModInvText.stringColor_(Color.new255(255,255,255, 255));
	};
});
~amplitudeModInvSelect  = CheckBox.new(~amplitudeGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~amplitudeModInvText = StaticText.new(~amplitudeGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~amplitude4 = Button.new(~amplitudeGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (amplitudeModInvFlag) {
		amplitudeModInvFlag = false;
		~amplitudeModInvSelect.value_(false);
	} {
		amplitudeModInvFlag = true;
		~amplitudeModInvSelect.value_(true);
	};
});
~amplitudeSusSelect  = CheckBox.new(~amplitudeGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 3), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~amplitudeSusText = StaticText.new(~amplitudeGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 3), ~buttonWidth, ~buttonHeight))
.string_("Sustain")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~amplitude5 = Button.new(~amplitudeGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 3), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (amplitudeSusFlag) {
		amplitudeSusFlag = false;
		~amplitudeSusSelect.value_(false);
	} {
		amplitudeSusFlag = true;
		~amplitudeSusSelect.value_(true);
	};
});




// -----------
// Time
// -----------
~timeGroup = UserView(w, Rect((~graphWidth + ~margin), (w.bounds.height * 0.2 + (~margin * 8.68)),  (~margin * 3), ~margin))
.background_(Color.new255(217, 56, 126, 100));
~timeHeading = StaticText.new(~timeGroup, Rect((~buttonMarginLeft / 3), (~buttonMarginLeft / 3), (~buttonWidth * 2), ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Tidsaspekter")
.align_(\left)
.font_(Font("Arial", ~headingSize))
.visible_(true);
// Attack time
~attackSelect  = CheckBox.new(~timeGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~attackText = StaticText.new(~timeGroup, Rect((~buttonMarginLeft + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Attack")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~time1 = Button.new(~timeGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (attackFlag) {
		attackFlag = false;
		attackInvFlag = false;
		~attackSelect.value_(false);
		~attackInvSelect.value_(false);
		~time2.enabled_(false);
		~attackInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		attackFlag = true;
		~attackSelect.value_(true);
		~time2.enabled_(true);
		~attackInvText.stringColor_(Color.new255(255,255,255, 255));
	};
});
~attackInvSelect  = CheckBox.new(~timeGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~attackInvText = StaticText.new(~timeGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~time2 = Button.new(~timeGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (attackInvFlag) {
		attackInvFlag = false;
		~attackInvSelect.value_(false);
	} {
		attackInvFlag = true;
		~attackInvSelect.value_(true);
	};
});
// Release time
~releaseSelect  = CheckBox.new(~timeGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~releaseText = StaticText.new(~timeGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Release")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~time3 = Button.new(~timeGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (releaseFlag) {
		releaseFlag = false;
		releaseInvFlag = false;
		~releaseSelect.value_(false);
		~releaseInvSelect.value_(false);
		~time4.enabled_(false);
		~releaseInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		releaseFlag = true;
		~releaseSelect.value_(true);
		~time4.enabled_(true);
		~releaseInvText.stringColor_(Color.new255(255,255,255, 255));
	};
});
~releaseInvSelect  = CheckBox.new(~timeGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~releaseInvText = StaticText.new(~timeGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~time4 = Button.new(~timeGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (releaseInvFlag) {
		releaseInvFlag = false;
		~releaseInvSelect.value_(false);
	} {
		releaseInvFlag = true;
		~releaseInvSelect.value_(true);
	};
});




// -----------
// Room
// -----------
~roomGroup = UserView(w, Rect((~graphWidth + ~margin), (w.bounds.height * 0.2 + (~margin * 9.79)),  (~margin * 3), ~margin))
.background_(Color.new255(217, 56, 56, 100));
~roomHeading = StaticText.new(~roomGroup, Rect((~buttonMarginLeft / 3), (~buttonMarginLeft / 3), (~buttonWidth * 2), ~buttonHeight))
.stringColor_(Color.new255(255,255,255, 255))
.string_("Rumseffekter")
.align_(\left)
.font_(Font("Arial", ~headingSize))
.visible_(true);
// Attack time
~reverbSelect  = CheckBox.new(~roomGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~reverbText = StaticText.new(~roomGroup, Rect((~buttonMarginLeft + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Efterklang")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~room1 = Button.new(~roomGroup, Rect(~buttonMarginLeft, ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (reverbFlag) {
		reverbFlag = false;
		reverbInvFlag = false;
		~reverbSelect.value_(false);
		~reverbInvSelect.value_(false);
		~room2.enabled_(false);
		~reverbInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		reverbFlag = true;
		~reverbSelect.value_(true);
		~room2.enabled_(true);
		~reverbInvText.stringColor_(Color.new255(255,255,255, 255));
	};
});
~reverbInvSelect  = CheckBox.new(~roomGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~reverbInvText = StaticText.new(~roomGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~room2 = Button.new(~roomGroup, Rect((~buttonMarginLeft * 8), ~buttonMarginTop, ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (reverbInvFlag) {
		reverbInvFlag = false;
		~reverbInvSelect.value_(false);
	} {
		reverbInvFlag = true;
		~reverbInvSelect.value_(true);
	};
});
~delaySelect  = CheckBox.new(~roomGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("");
~delayText = StaticText.new(~roomGroup, Rect((~buttonMarginLeft + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Eko")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 255))
.font_(Font("Arial", ~textSize))
.visible_(true);
~room3 = Button.new(~roomGroup, Rect(~buttonMarginLeft, (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(true)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (delayFlag) {
		delayFlag = false;
		delayInvFlag = false;
		~delaySelect.value_(false);
		~delayInvSelect.value_(false);
		~room4.enabled_(false);
		~delayInvText.stringColor_(Color.new255(255,255,255, 100));
	} {
		delayFlag = true;
		~delaySelect.value_(true);
		~room4.enabled_(true);
		~delayInvText.stringColor_(Color.new255(255,255,255, 255));
	};
});
~delayInvSelect  = CheckBox.new(~roomGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonHeight, ~buttonHeight))
.enabled_(true)
.action_({
})
.string_("")
.enabled_(false);
~delayInvText = StaticText.new(~roomGroup, Rect((~buttonMarginLeft * 8 + ~buttonHeight), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.string_("Spegla")
.align_(\left)
.stringColor_(Color.new255(255,255,255, 100))
.font_(Font("Arial", ~textSize))
.visible_(true);
~room4 = Button.new(~roomGroup, Rect((~buttonMarginLeft * 8), (~buttonMarginTop * 2), ~buttonWidth, ~buttonHeight))
.enabled_(false)
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (delayInvFlag) {
		delayInvFlag = false;
		~delayInvSelect.value_(false);
	} {
		delayInvFlag = true;
		~delayInvSelect.value_(true);
	};
});








~lineGraph = {
	for (0, (data.size - 2), { arg i;
		if (data1Flag) {
			var xPos = (~margin + (~xStepSize * i));
			var yPos = (~graphView.bounds.height - ~margin) - (data1[i] * ~yStepSize);
			var yPos2 = (~graphView.bounds.height - ~margin) - (data1[(i + 1)] * ~yStepSize);

			Pen.width = 2;
			Pen.strokeColor = Color.new255(0,100,0, 155);
			Pen.line(xPos@yPos, (xPos + ~xStepSize)@yPos2);
			Pen.stroke;
		};
		if (data2Flag) {
			var xPos = (~margin + (~xStepSize * i));
			var yPos = (~graphView.bounds.height - ~margin) - (data2[i] * ~yStepSize * 2);
			var yPos2 = (~graphView.bounds.height - ~margin) - (data2[(i + 1)] * ~yStepSize * 2);

			Pen.width = 2;
			Pen.strokeColor = Color.new255(0,0,200, 155);
			Pen.line(xPos@yPos, (xPos + ~xStepSize)@yPos2);
			Pen.stroke;
		};
	});
};

~barGraph = {
	for (0, (data.size - 1), { arg i;
		if (data1Flag) {
			var xPos = (~margin + (~xStepSize * i));
			var yPos = (~graphView.bounds.height - ~margin) - (data1[i] * ~yStepSize);
			var yHeight = (data1[i] * ~yStepSize);

			Pen.fillColor = Color.new255(0,100,0, 100);
			Pen.fillRect(Rect(xPos, yPos, ~xStepSize, yHeight));
			Pen.strokeColor = Color.new255(0,0,0, 255);
			Pen.strokeRect(Rect(xPos, yPos, ~xStepSize, yHeight));
		};
		if (data2Flag) {
			var xPos = (~margin + (~xStepSize * i));
			var yPos = (~graphView.bounds.height - ~margin) - (data2[i] * ~yStepSize * 2);
			var yHeight = (data2[i] * ~yStepSize * 2);

			Pen.fillColor = Color.new255(0,0,200, 100);
			Pen.fillRect(Rect(xPos, yPos, ~xStepSize, yHeight));
			Pen.strokeColor = Color.new255(0,0,0, 255);
			Pen.strokeRect(Rect(xPos, yPos, ~xStepSize, yHeight));
		};
	});
};




~outputEffectBus = Bus.audio(s, 2);

~outputVoice = Synth.new(\outputVoice, [\inputbus, ~outputEffectBus.index]).register;

~sonificationVoice = Synth.new(\sonificationVoice, [\bus, ~outputEffectBus.index, \frequency, 220]);

Synth.new(\sendMouse);



~tempProcess = Task({
	loop{
		h = ([48,51,55].choose.midicps) * (2**((0 .. 4).choose));
		~sonificationVoice.set(\frequency, h, \t_trig, 1);
		0.25.wait;//0.5
	};
});







NetAddr.langPort;
NetAddr.localAddr;

~filterLag = 0.01;
~graphYPos = ~windowHeight - w.bounds.height + ~graphView.bounds.top;
~oldData;
~oldFreq = 0;
~pitch = 220;
~soundlevel = 0;
~keyPressed = false;
~wLeft = w.bounds.left;
~wTop = w.bounds.top;
~xStepSize = 0;
//Hämta state och fixa allt men just ny disableas allt också...
OSCdef.new(\Dataset,
	{
	arg msg;
		~test = "We got a message!";
		~test.postln;
		msg.postln;
		~pitchFlag = msg[2];
		~pitchInvFlag = msg[3];
		~pitchQuantFlag = msg[4];
		~amplitudeFlag = msg[5];
		~amplitudeInvFlag = msg[6];
		~amplitudeSusFlag = msg[7];
		~amplitudeModFlag = msg[8];
		~amplitudeModInvFlag = msg[9];
		~wavemixFlag = msg[10];
		~wavemixInvFlag = msg[11];
		~attackFlag = msg[12];
		~attackInvFlag = msg[13];
		~releaseFlag = msg[14];
		~releaseInvFlag = msg[15];
		~clipFlag = msg[16];
		~clipInvFlag = msg[17];
		~noiseFlag = msg[18];
		~noiseType = msg[19];
		~waveForm = msg[20];
		~lpfFlag = msg[21];
		~lpfInvFlag = msg[22];
		~bpfFlag = msg[23];
		~bpfInvFlag = msg[24];
		~hpfFlag = msg[25];
		~hpfInvFlag = msg[26];
		~harmonyFlag = msg[27];
		~harmonyInvFlag = msg[28];
		~chordFlag = msg[29];
		~chordInvFlag = msg[30];
		~reverbFlag = msg[31];
		~reverbInvFlag = msg[32];
		~delayFlag = msg[33];
		~delayInvFlag = msg[34];
		~pwFlag = msg[35];
		~pwInvFlag = msg[36];
		~data1Flag = msg[37];
		~data2Flag = msg[38];
		~data2SonFlag = msg[39];
		~graphValue = msg[40];

		~waveForm.postln;
		~graphValue.postln;

		//Shameless test make on press later
		~sonificationVoice.set(\t_trig, 1, \gate, 1);

		if (~currentFilter != ~oldFilter) {
				~lagTime = 1;
				~oldFilter = ~currentFilter;
			} {
				~lagTime = 0.01;
			};
			if ((~pitchFlag == 1) || (~pitchQuantFlag== 1)) {
				~pitch = ~mapPitch.value(~graphValue);

				~graphValue.postln;

			} {
				~pitch = 440;
			};
			if ((~harmonyFlag == 1) || (~chordFlag == 1)) {
				~pitch1 = ~mapPitch1.value(~pitch, ~graphValue);
				~pitch2 = ~mapPitch2.value(~pitch, ~graphValue);
			} {
				~pitch1 = ~pitch;
				~pitch2 = ~pitch;
			};
			if (~amplitudeFlag== 1) {
				~soundlevel = ~mapAmplitude.value(~graphValue);
			} {
				~soundlevel = 0.5;
			};
			if (~wavemixFlag== 1) {
				~wavemix = ~mapWavemix.value(~graphValue);
				~sineLevel = 0;
				~triLevel = 0;
				~squareLevel = 0;
				~sawLevel = 0;
				~timbreMixLevel = 1;
			} {
				~wavemix = 0;
				~timbreMixLevel = 0;
			};
			if (~pwFlag== 1) {
				~pw = ~mapPw.value(~graphValue);
				~sineLevel = 0;
				~triLevel = 0;
				~squareLevel = 1;
				~sawLevel = 0;
			} {
				~pw = 0.5;
			};
			if (~attackFlag== 1) {
				~attack = ~mapAttack.value(~graphValue);
			} {
				~attack = 0.001;
			};
			if (~releaseFlag== 1) {
				~release = ~mapRelease.value(~graphValue);
			} {
				~release = 0.5;
			};
			if (~clipFlag== 1) {
				~clip = ~mapClip.value(~graphValue);
			} {
				~clip = 1;
			};
			if (~noiseFlag== 1) {
				~noise = 1;
			} {
				~noise = 0;
			};
			if (~noiseType == 1) {
				~whiteNoiseLevel = 0.5;
				~pinkNoiseLevel = 0;
				~crackleNoiseLevel = 0;
			} {
				if (~noiseType == 2) {
					~whiteNoiseLevel = 0;
					~pinkNoiseLevel = 1;
					~crackleNoiseLevel = 0;
				} {
					if (~noiseType == 3) {
						~whiteNoiseLevel = 0;
						~pinkNoiseLevel = 0;
						~crackleNoiseLevel = 1;
					};
				};
			};
			if (~amplitudeModFlag== 1) {
				~amplitudeMod = ~mapAmplitudeMod.value(~graphValue);
				~amplitudeModFreq = ~mapAmplitudeModFreq.value(~graphValue);
			} {
				~amplitudeMod = 1;
				~amplitudeModFreq = 1;
			};
			if (~amplitudeSusFlag== 1) {
				~sustain = 1;
			} {
				~sustain = 0;
			};

			if (~lpfFlag== 1) {
				~lpfLevel = 1;
				~lpfCutoff = ~maplpfCutoff.value(~graphValue);
				if (abs(~lpfCutoff - ~oldFreq) > 4000) {
					~filterLag = 1;
				} {
					~filterLag = 0.01;
				};
				~oldFreq = ~lpfCutoff;
			} {
				~lpfLevel = 0;
			};
			if (~bpfFlag== 1) {
				~bpfLevel = 1;
				~bpfCutoff = ~mapbpfCutoff.value(~graphValue);
				if (abs(~bpfCutoff - ~oldFreq) > 4000) {
					~filterLag = 1;
				} {
					~filterLag = 0.01;
				};
				~oldFreq = ~bpfCutoff;
			} {
				~bpfLevel = 0;
			};
			if (~hpfFlag== 1) {
				~hpfLevel = 1;
				~hpfCutoff = ~maphpfCutoff.value(~graphValue);
				if (abs(~hpfCutoff - ~oldFreq) > 4000) {
					~filterLag = 1;
				} {
					~filterLag = 0.01;
				};
				~oldFreq = ~hpfCutoff;
			} {
				~hpfLevel = 0;
			};
			if ((~lpfFlag== 1) || (~bpfFlag== 1) || (~hpfFlag== 1)) {
				~mixedSoundLevel = 0;
			} {
				~mixedSoundLevel = 1;
			};
			if (~reverbFlag== 1) {
				~reverbMix = ~mapreverbMix.value(~graphValue);
				~reverberation  = ~mapreverberation.value(~graphValue);
			} {
				~reverbMix = 0.1;
				~reverberation = 0.5;
			};
			if (~delayFlag== 1) {
				~delayTime = ~mapdelayTime.value(~graphValue);//0.33;
				~decay = ~mapdecay.value(~graphValue);//0.5;
				~delayLevel = 1;
			} {
				~delayLevel = 0;
			};








			~sonificationVoice.set(\frequency, ~pitch, \frequency1, ~pitch1, \frequency2, ~pitch2, \soundlevel, ~soundlevel, \wavemix, ~wavemix, \attack, ~attack, \release, ~release, \clip, ~clip, \noiselevel, ~noise, \lfoLevel, ~amplitudeMod, \lfoFreq, ~amplitudeModFreq, \pinkNoiseLevel, ~pinkNoiseLevel, \whiteNoiseLevel, ~whiteNoiseLevel, \crackleNoiseLevel, ~crackleNoiseLevel, \sustain, ~sustain, \timbreMixLevel, ~timbreMixLevel, \sineLevel, ~sineLevel, \triLevel, ~triLevel, \squareLevel, ~squareLevel, \sawLevel, ~sawLevel, \mixedSoundLevel, ~mixedSoundLevel, \lpfLevel, ~lpfLevel, \bpfLevel, ~bpfLevel, \hpfLevel, ~hpfLevel, \lpfCutoff, ~lpfCutoff, \bpfCutoff, ~bpfCutoff, \hpfCutoff, ~hpfCutoff, \pw, ~pw, \lagTime, ~lagTime, \filterLag, ~filterLag);
			~outputVoice.set(\reverbMix, ~reverbMix, \reverberation, ~reverberation, \delayTime, ~delayTime, \decay, ~decay, \delayLevel, ~delayLevel);
		};



	, '/dataset');

~filterLag = 0.01;
~graphYPos = ~windowHeight - w.bounds.height + ~graphView.bounds.top;
~oldData;
~oldFreq = 0;
~pitch = 220;
~soundlevel = 0;
~keyPressed = false;
~wLeft = w.bounds.left;
~wTop = w.bounds.top;
~xStepSize = 0;
o = OSCFunc({ arg msg, time, addr, recvPort;
	var mouseXPos = 0;
	var mouseYPos = 0;
	var insideGraph, newData;
	if (~graphType == 1) {
		mouseXPos = (msg[3] - ~wLeft) - (~xStepSize / 2);
	} {
		mouseXPos = (msg[3] - ~wLeft);
	};
	mouseYPos = (msg[4] + ~wTop);
	insideGraph = (mouseXPos >= ~margin) && (mouseXPos <= ~graphWidth) && (mouseYPos >= (~graphYPos + ~margin)) && (mouseYPos <= (~graphYPos + ~graphHeight - ~margin));
	newData = ((mouseXPos - ~margin) / ~xStepSize).round;

	if (insideGraph) {
		if (newData != ~oldData) {
			~keyPressed = true;
			~oldData = newData;
			if (data[newData] != nil) {
				var yPos;
				if (data2SonFlag) {
					yPos = (data[newData] * ~yStepSize * 2);
				} {
					yPos = (data[newData] * ~yStepSize);
				};
				switch (~graphType,
					0, {
						{~markerView.moveTo((~margin + (newData * ~xStepSize) - (~markerSize / 2)), (~graphHeight - ~margin - yPos - (~markerSize / 2)))}.defer;
					},
					1, {
						{~markerView.moveTo((~margin + (newData * ~xStepSize) + (~xStepSize / 2) - (~markerSize / 2)), (~graphHeight - ~margin - yPos - (~markerSize / 2)))}.defer;
				});
			};
		};
		if ((msg[5] == 1) && (~keyPressed)){
			~keyPressed = false;
			{~markerView.visible_(true)}.defer;
			~sonificationVoice.set(\t_trig, 1, \gate, 1);
		} {
			if (msg[5] == 0) {
				~keyPressed = true;
				{~markerView.visible_(false)}.defer;
				~sonificationVoice.set(\t_trig, 0, \gate, 0);
			};
		};
		if ((~keyPressed == false) && (data[newData] != nil)){


			if (~currentFilter != ~oldFilter) {
				~lagTime = 1;
				~oldFilter = ~currentFilter;
			} {
				~lagTime = 0.01;
			};
			if ((pitchFlag) || (pitchQuantFlag)) {
				~pitch = ~mapPitch.value(newData);

				newData.postln;

			} {
				~pitch = 440;
			};
			if ((harmonyFlag) || (chordFlag)) {
				~pitch1 = ~mapPitch1.value(~pitch, newData);
				~pitch2 = ~mapPitch2.value(~pitch, newData);
			} {
				~pitch1 = ~pitch;
				~pitch2 = ~pitch;
			};
			if (amplitudeFlag) {
				~soundlevel = ~mapAmplitude.value(newData);
			} {
				~soundlevel = 0.5;
			};
			if (wavemixFlag) {
				~wavemix = ~mapWavemix.value(newData);
				~sineLevel = 0;
				~triLevel = 0;
				~squareLevel = 0;
				~sawLevel = 0;
				~timbreMixLevel = 1;
			} {
				~wavemix = 0;
				~timbreMixLevel = 0;
			};
			if (pwFlag) {
				~pw = ~mapPw.value(newData);
				~sineLevel = 0;
				~triLevel = 0;
				~squareLevel = 1;
				~sawLevel = 0;
			} {
				~pw = 0.5;
			};
			if (attackFlag) {
				~attack = ~mapAttack.value(newData);
			} {
				~attack = 0.001;
			};
			if (releaseFlag) {
				~release = ~mapRelease.value(newData);
			} {
				~release = 0.5;
			};
			if (clipFlag) {
				~clip = ~mapClip.value(newData);
			} {
				~clip = 1;
			};
			if (noiseFlag) {
				~noise = 1;
			} {
				~noise = 0;
			};
			if (noiseType == 1) {
				~whiteNoiseLevel = 0.5;
				~pinkNoiseLevel = 0;
				~crackleNoiseLevel = 0;
			} {
				if (noiseType == 2) {
					~whiteNoiseLevel = 0;
					~pinkNoiseLevel = 1;
					~crackleNoiseLevel = 0;
				} {
					if (noiseType == 3) {
						~whiteNoiseLevel = 0;
						~pinkNoiseLevel = 0;
						~crackleNoiseLevel = 1;
					};
				};
			};
			if (amplitudeModFlag) {
				~amplitudeMod = ~mapAmplitudeMod.value(newData);
				~amplitudeModFreq = ~mapAmplitudeModFreq.value(newData);
			} {
				~amplitudeMod = 1;
				~amplitudeModFreq = 1;
			};
			if (amplitudeSusFlag) {
				~sustain = 1;
			} {
				~sustain = 0;
			};

			if (lpfFlag) {
				~lpfLevel = 1;
				~lpfCutoff = ~maplpfCutoff.value(newData);
				if (abs(~lpfCutoff - ~oldFreq) > 4000) {
					~filterLag = 1;
				} {
					~filterLag = 0.01;
				};
				~oldFreq = ~lpfCutoff;
			} {
				~lpfLevel = 0;
			};
			if (bpfFlag) {
				~bpfLevel = 1;
				~bpfCutoff = ~mapbpfCutoff.value(newData);
				if (abs(~bpfCutoff - ~oldFreq) > 4000) {
					~filterLag = 1;
				} {
					~filterLag = 0.01;
				};
				~oldFreq = ~bpfCutoff;
			} {
				~bpfLevel = 0;
			};
			if (hpfFlag) {
				~hpfLevel = 1;
				~hpfCutoff = ~maphpfCutoff.value(newData);
				if (abs(~hpfCutoff - ~oldFreq) > 4000) {
					~filterLag = 1;
				} {
					~filterLag = 0.01;
				};
				~oldFreq = ~hpfCutoff;
			} {
				~hpfLevel = 0;
			};
			if ((lpfFlag) || (bpfFlag) || (hpfFlag)) {
				~mixedSoundLevel = 0;
			} {
				~mixedSoundLevel = 1;
			};
			if (reverbFlag) {
				~reverbMix = ~mapreverbMix.value(newData);
				~reverberation  = ~mapreverberation.value(newData);
			} {
				~reverbMix = 0.1;
				~reverberation = 0.5;
			};
			if (delayFlag) {
				~delayTime = ~mapdelayTime.value(newData);//0.33;
				~decay = ~mapdecay.value(newData);//0.5;
				~delayLevel = 1;
			} {
				~delayLevel = 0;
			};

			~sonificationVoice.set(\frequency, ~pitch, \frequency1, ~pitch1, \frequency2, ~pitch2, \soundlevel, ~soundlevel, \wavemix, ~wavemix, \attack, ~attack, \release, ~release, \clip, ~clip, \noiselevel, ~noise, \lfoLevel, ~amplitudeMod, \lfoFreq, ~amplitudeModFreq, \pinkNoiseLevel, ~pinkNoiseLevel, \whiteNoiseLevel, ~whiteNoiseLevel, \crackleNoiseLevel, ~crackleNoiseLevel, \sustain, ~sustain, \timbreMixLevel, ~timbreMixLevel, \sineLevel, ~sineLevel, \triLevel, ~triLevel, \squareLevel, ~squareLevel, \sawLevel, ~sawLevel, \mixedSoundLevel, ~mixedSoundLevel, \lpfLevel, ~lpfLevel, \bpfLevel, ~bpfLevel, \hpfLevel, ~hpfLevel, \lpfCutoff, ~lpfCutoff, \bpfCutoff, ~bpfCutoff, \hpfCutoff, ~hpfCutoff, \pw, ~pw, \lagTime, ~lagTime, \filterLag, ~filterLag);
			~outputVoice.set(\reverbMix, ~reverbMix, \reverberation, ~reverberation, \delayTime, ~delayTime, \decay, ~decay, \delayLevel, ~delayLevel);
		};
	};

}, '/mousePosition');




~mapPitch = { arg position;
	var lowFreq = 110;
	var highFreq = 1760;
	var freq;
	if (pitchInvFlag) {
		freq = (lowFreq + highFreq) - linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), lowFreq, highFreq);
	} {
		freq = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), lowFreq, highFreq);
	};
	if (pitchQuantFlag) {
		freq = ~mapTones.value(freq);
	};
	freq;
};
~mapTones = { arg freq;
	var incomingNote = freq.cpsmidi;
	var comparisonValue;
	var notePosition;
	var mappedFreq;
	for (0, ~quantTones.size-1){ arg index;
		var tempValue = (~quantTones[index] - incomingNote).abs;

		if (comparisonValue.isNumber ==  false) {
			comparisonValue = tempValue;
		};

		if (tempValue < comparisonValue) {
			comparisonValue = tempValue;
			notePosition = index;
		};
	};
	mappedFreq = ~quantTones[notePosition].midicps;
	mappedFreq.value;
};
~mapPitch1 = { arg freq, position;
	var mappedFreq;
	var detune;
	if (chordInvFlag) {
		detune = linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.2599, 1.1892);
		mappedFreq = freq * detune;
	} {
		if (chordFlag) {
			detune = linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.1892, 1.2599);
			mappedFreq = freq * detune;
		} {
			if (harmonyInvFlag) {
				mappedFreq = freq * linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.02973, 1);
			} {
				mappedFreq = freq * linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1, 1.02973);
			};
		};
	};
	mappedFreq;
};
~mapPitch2 = { arg freq, position;
	var mappedFreq;
	var detune = 1.4983;
	if (chordFlag) {
		mappedFreq = freq * detune;
	} {
		if (harmonyInvFlag) {
			mappedFreq = freq * (linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.97027, 2) - 1);
		} {
			mappedFreq = freq * (linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 2, 1.97027) - 1);
		};
	};
	mappedFreq;
};
~mapAmplitude = { arg position;
	var level;
	if (amplitudeInvFlag) {
		level = 1 - (linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.05, 2) - 1);
	} {
		level = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.05, 2) - 1;
	};
	level;
};
~mapAmplitudeMod = { arg position;
	var level;
	if (amplitudeModInvFlag) {
		level = linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 0, 0.75);
	} {
		level = linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 0.75, 0);
	};
	level;
};
~mapAmplitudeModFreq = { arg position;
	var freq;
	if (amplitudeModInvFlag) {
		freq = linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 15, 4);
	} {
		freq = linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 4, 15);
	};
	freq;
};
~mapWavemix = { arg position;
	var mixlevel;
	if (wavemixInvFlag) {
		mixlevel = 1 - (linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1, 2) - 1);
	} {
		mixlevel = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1, 2) - 1;
	};
	mixlevel;
};
~mapPw = { arg position;
	var pw;
	if (pwInvFlag) {
		pw = 1 - (linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.95, 1.5) - 1);
	} {
		pw = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.5, 1.95) - 1;
	};
	pw;
};
~mapAttack = { arg position;
	var attackTime;
	if (attackInvFlag) {
		attackTime = 0.5 - (linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.0001, 1.5) - 1);
	} {
		attackTime = linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.0001, 1.5) - 1;
	};
	attackTime;
};
~mapRelease = { arg position;
	var releaseTime;
	if (releaseInvFlag) {
		releaseTime = 1 - (linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.5, 5) - 1);
	} {
		releaseTime = linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.1, 3) - 1;
	};
	releaseTime;
};
~mapClip = { arg position;
	var clip;
	if (clipInvFlag) {
		clip = 1 - (linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 2, 1.1) - 1);
	} {
		clip = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 2, 1.1) - 1;
	};
	clip;
};
~maplpfCutoff = { arg position;
	var lpfCutoff;
	var lowFreq = 100;
	var highFreq = 10000;
	if (lpfInvFlag) {
		lpfCutoff = (lowFreq + highFreq) - linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), lowFreq, highFreq);
	} {
		lpfCutoff = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), lowFreq, highFreq);
	};
	lpfCutoff;
};
~mapbpfCutoff = { arg position;
	var bpfCutoff;
	var lowFreq = 100;
	var highFreq = 10000;
	if (bpfInvFlag) {
		bpfCutoff = (lowFreq + highFreq) - linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), lowFreq, highFreq);
	} {
		bpfCutoff = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), lowFreq, highFreq);
	};
	bpfCutoff;
};
~maphpfCutoff = { arg position;
	var hpfCutoff;
	var lowFreq = 100;
	var highFreq = 10000;
	if (hpfInvFlag) {
		hpfCutoff = (lowFreq + highFreq) - linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), lowFreq, highFreq);
	} {
		hpfCutoff = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), lowFreq, highFreq);
	};
	hpfCutoff;
};
~mapreverbMix = { arg position;
	var level;
	if (reverbInvFlag) {
		level = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.5, 1) - 1;
	} {
		level = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1, 1.5) - 1;
	};
	level;
};
~mapreverberation = { arg position;
	var level;
	if (reverbInvFlag) {
		level = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 2, 1.5) - 1;
	} {
		level = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.5, 2) - 1;
	};
	level;
};
~mapdelayTime = { arg position;
	var level;
	if (delayInvFlag) {
		level = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.5, 1.01) - 1;
	} {
		level = linexp(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.01, 1.5) - 1;
	};
	level;
};
~mapdecay = { arg position;
	var level;
	if (delayInvFlag) {
		level = linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.75, 1.3) - 1;
	} {
		level = linlin(data[position], ~minOfArray.value(data), ~maxOfArray.value(data), 1.3, 1.75) - 1;
	};
	level;
};



~maxOfArray = { arg inputArray;
	var maxValue = 0;
	for (0, (inputArray.size - 1), { arg i;
		if (maxValue < inputArray[i]) {
			maxValue = inputArray[i];
		};
	});
	maxValue;
};

~minOfArray = { arg inputArray;
	var minValue = inputArray[0];
	for (0, (inputArray.size - 1), { arg i;
		if (minValue > inputArray[i]) {
			minValue = inputArray[i];
		};
	});
	minValue;
};

CmdPeriod.doOnce({
	w.close;
	//s.freeAll;
	//s.quit;
});





)

~tempProcess.play;

~tempProcess.stop;

s.scope