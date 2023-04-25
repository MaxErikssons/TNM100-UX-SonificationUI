(

SynthDef(\sonificationVoice, { arg bus, frequency = 440, frequency1 = 440, frequency2 = 440, soundlevel = 0, wavemix = 0, attack = 0.001, release = 0.5, clip = 1, noiselevel = 0, lfoLevel = 1, lfoFreq = 10, timbreMixLevel = 0, sineLevel = 0, triLevel = 0, squareLevel = 0, sawLevel = 0, whiteNoiseLevel = 0, pinkNoiseLevel = 0, crackleNoiseLevel = 0, t_trig = 0, gate = 0, sustain = 0, lpfCutoff = 2500, bpfCutoff = 2500, hpfCutoff = 2500, mixedSoundLevel = 1, lpfLevel = 0, bpfLevel = 0, hpfLevel = 0, pw = 0.5, lagTime = 0.01, filterLag = 0.01;
	var noise = WhiteNoise.ar(whiteNoiseLevel/5) + PinkNoise.ar(pinkNoiseLevel/5) + Dust.ar(440, crackleNoiseLevel/5);
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
var data3 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.076492, 0.079005, 0.084885, 0.088337, 0.096258, 0.097175, 0.103193, 0.106328, 0.102333, 0.105995, 0.126754, 0.181060, 0.175086, 0.192159, 0.188051, 0.184955, 0.190028, 0.191519, 0.210595, 0.110901, 0.018423, 0.019830, 0.015163, 0.020875, 0.011728, 0.054806, 0.161188, 0.172952, 0.184450, 0.201427, 0.252323, 0.303659, 0.357944, 0.444403, 0.506947, 0.610716, 0.708581, 0.802197, 0.904437, 1.000939, 1.230341, 1.337886, 1.443976, 1.507685, 1.604603, 1.710847, 1.810457, 1.905972, 2.007809, 2.108840, 2.210180, 2.309122, 2.411864, 2.450764, 2.500845, 2.609632, 2.704385, 2.804983, 2.703913, 2.756943, 2.749949, 2.759243, 2.765760, 2.769914, 2.909337, 2.952995, 3.005412, 3.159496, 3.354391, 3.506507, 3.553540, 3.415310, 3.386370, 3.510872, 3.527619, 3.554374, 3.570191, 3.570417, 3.602943, 3.653106, 3.757291, 3.832005, 3.903441, 4.005438, 4.101041, 4.204473, 4.310312, 4.372367, 4.425603, 4.559353, 4.643761, 4.711494, 4.784990, 4.842295, 4.882203, 4.915204, 4.955076, 5.000810, 5.051542, 5.103395, 5.111341];

var data2 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
    2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0,
    3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0,
    4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0,
    5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0,
    6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0,
    7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0,
    8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0,
    9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0,
    10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0,
    11.0, 11.0, 11.0, 11.0, 11.0, 11.0, 11.0, 11.0, 11.0, 11.0,
    12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0,
    13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0,
    14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0,
];

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


~outputEffectBus = Bus.audio(s, 2);

~outputVoice = Synth.new(\outputVoice, [\inputbus, ~outputEffectBus.index]).register;

~sonificationVoice = Synth.new(\sonificationVoice, [\bus, ~outputEffectBus.index, \frequency, 220]);

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
//~graphYPos = ~windowHeight - w.bounds.height + ~graphView.bounds.top;
~oldData;
~oldFreq = 0;
~pitch = 220;
~soundlevel = 0;
~keyPressed = false;
//~wLeft = w.bounds.left;
//~wTop = w.bounds.top;
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
		~dataString = msg[41];


		~dataString.postln;

	if (~dataString== 1) {
			~data = data1;
			} {
			~data = data2;
			};
		~data.postln;

		//Shameless test make on press later
		~sonificationVoice.set(\t_trig, 1, \gate, 1);

		if (~waveForm == 1) {
				~sineLevel = 1;
				~triLevel = 0;
				~squareLevel = 0;
				~sawLevel = 0;
			} {
				if (~waveForm == 2) {
					~sineLevel = 0;
					~triLevel = 1;
					~squareLevel = 0;
					~sawLevel = 0;
				} {
					if (~waveForm == 3) {
						~sineLevel = 0;
						~triLevel = 0;
						~squareLevel = 1;
						~sawLevel = 0;
					} {
						if (~waveForm == 4) {
							~sineLevel = 0;
							~triLevel = 0;
							~squareLevel = 0;
							~sawLevel = 1;
						} {
							~sineLevel = 0;
							~triLevel = 0;
							~squareLevel = 0;
							~sawLevel = 0;
						};
					};
				};
			};
		~squareLevel.postln;

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


~mapPitch = { arg position;
	var lowFreq = 110;
	var highFreq = 1760;
	var freq;
	if (~pitchInvFlag==1) {
		freq = (lowFreq + highFreq) - linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), lowFreq, highFreq);
	} {
		freq = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), lowFreq, highFreq);
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
	if (~chordInvFlag==1) {
		detune = linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.2599, 1.1892);
		mappedFreq = freq * detune;
	} {
		if (~chordFlag==1) {
			detune = linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.1892, 1.2599);
			mappedFreq = freq * detune;
		} {
			if (~harmonyInvFlag==1) {
				mappedFreq = freq * linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.02973, 1);
			} {
				mappedFreq = freq * linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1, 1.02973);
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
		if (~harmonyInvFlag==1) {
			mappedFreq = freq * (linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.97027, 2) - 1);
		} {
			mappedFreq = freq * (linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 2, 1.97027) - 1);
		};
	};
	mappedFreq;
};
~mapAmplitude = { arg position;
	var level;
	if (~amplitudeInvFlag==1) {
		level = 1 - (linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.05, 2) - 1);
	} {
		level = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.05, 2) - 1;
	};
	level;
};
~mapAmplitudeMod = { arg position;
	var level;
	if (~amplitudeModInvFlag==1) {
		level = linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 0, 0.75);
	} {
		level = linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 0.75, 0);
	};
	level;
};
~mapAmplitudeModFreq = { arg position;
	var freq;
	if (~amplitudeModInvFlag==1) {
		freq = linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 15, 4);
	} {
		freq = linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 4, 15);
	};
	freq;
};
~mapWavemix = { arg position;
	var mixlevel;
	if (~wavemixInvFlag==1) {
		mixlevel = 1 - (linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1, 2) - 1);
	} {
		mixlevel = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1, 2) - 1;
	};
	mixlevel;
};
~mapPw = { arg position;
	var pw;
	if (~pwInvFlag==1) {
		pw = 1 - (linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.95, 1.5) - 1);
	} {
		pw = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.5, 1.95) - 1;
	};
	pw;
};
~mapAttack = { arg position;
	var attackTime;
	if (~attackInvFlag==1) {
		attackTime = 0.5 - (linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.0001, 1.5) - 1);
	} {
		attackTime = linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.0001, 1.5) - 1;
	};
	attackTime;
};
~mapRelease = { arg position;
	var releaseTime;
	if (~releaseInvFlag==1) {
		releaseTime = 1 - (linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.5, 5) - 1);
	} {
		releaseTime = linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.1, 3) - 1;
	};
	releaseTime;
};
~mapClip = { arg position;
	var clip;
	if (~clipInvFlag==1) {
		clip = 1 - (linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 2, 1.1) - 1);
	} {
		clip = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 2, 1.1) - 1;
	};
	clip;
};
~maplpfCutoff = { arg position;
	var lpfCutoff;
	var lowFreq = 100;
	var highFreq = 10000;
	if (~lpfInvFlag==1) {
		lpfCutoff = (lowFreq + highFreq) - linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), lowFreq, highFreq);
	} {
		lpfCutoff = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), lowFreq, highFreq);
	};
	lpfCutoff;
};
~mapbpfCutoff = { arg position;
	var bpfCutoff;
	var lowFreq = 100;
	var highFreq = 10000;
	if (~bpfInvFlag==1) {
		bpfCutoff = (lowFreq + highFreq) - linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), lowFreq, highFreq);
	} {
		bpfCutoff = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), lowFreq, highFreq);
	};
	bpfCutoff;
};
~maphpfCutoff = { arg position;
	var hpfCutoff;
	var lowFreq = 100;
	var highFreq = 10000;
	if (~hpfInvFlag==1) {
		hpfCutoff = (lowFreq + highFreq) - linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), lowFreq, highFreq);
	} {
		hpfCutoff = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), lowFreq, highFreq);
	};
	hpfCutoff;
};
~mapreverbMix = { arg position;
	var level;
	if (~reverbInvFlag==1) {
		level = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.5, 1) - 1;
	} {
		level = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1, 1.5) - 1;
	};
	level;
};
~mapreverberation = { arg position;
	var level;
	if (~reverbInvFlag==1) {
		level = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 2, 1.5) - 1;
	} {
		level = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.5, 2) - 1;
	};
	level;
};
~mapdelayTime = { arg position;
	var level;
	if (~delayInvFlag==1) {
		level = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.5, 1.01) - 1;
	} {
		level = linexp(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.01, 1.5) - 1;
	};
	level;
};
~mapdecay = { arg position;
	var level;
	if (~delayInvFlag==1) {
		level = linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.75, 1.3) - 1;
	} {
		level = linlin(~data[position], ~minOfArray.value(~data), ~maxOfArray.value(~data), 1.3, 1.75) - 1;
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