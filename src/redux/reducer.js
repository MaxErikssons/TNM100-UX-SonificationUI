import { UPDATE_FLAG, CHANGE_SETTING, CHANGE_PROFILE } from './actions';

const firstState = {
	pitchFlag: 1,
	pitchInvFlag: 0,
	pitchQuantFlag: 0,
	amplitudeFlag: 0,
	amplitudeInvFlag: 0,
	amplitudeSusFlag: 0,
	amplitudeModFlag: 0,
	amplitudeModInvFlag: 0,
	wavemixFlag: 0,
	wavemixInvFlag: 0,
	attackFlag: 0,
	attackInvFlag: 0,
	releaseFlag: 0,
	releaseInvFlag: 0,
	clipFlag: 0,
	clipInvFlag: 0,
	noiseFlag: 0,
	noiseType: 0,
	waveForm: 1,
	lpfFlag: 0,
	lpfInvFlag: 0,
	bpfFlag: 0,
	bpfInvFlag: 0,
	hpfFlag: 0,
	hpfInvFlag: 0,
	harmonyFlag: 0,
	harmonyInvFlag: 0,
	chordFlag: 0,
	chordInvFlag: 0,
	reverbFlag: 0,
	reverbInvFlag: 0,
	delayFlag: 0,
	delayInvFlag: 0,
	pwFlag: 0,
	pwInvFlag: 0,
	data1Flag: 1,
	data2Flag: 0,
	data2SonFlag: 0,
	graphValue: 0,
	dataString: 1,
};

const secondaryState = {
	pitchFlag: 1,
	pitchInvFlag: 0,
	pitchQuantFlag: 0,
	amplitudeFlag: 0,
	amplitudeInvFlag: 0,
	amplitudeSusFlag: 0,
	amplitudeModFlag: 0,
	amplitudeModInvFlag: 0,
	wavemixFlag: 0,
	wavemixInvFlag: 0,
	attackFlag: 0,
	attackInvFlag: 0,
	releaseFlag: 0,
	releaseInvFlag: 0,
	clipFlag: 0,
	clipInvFlag: 0,
	noiseFlag: 0,
	noiseType: 0,
	waveForm: 1,
	lpfFlag: 0,
	lpfInvFlag: 0,
	bpfFlag: 0,
	bpfInvFlag: 0,
	hpfFlag: 0,
	hpfInvFlag: 0,
	harmonyFlag: 0,
	harmonyInvFlag: 0,
	chordFlag: 0,
	chordInvFlag: 0,
	reverbFlag: 0,
	reverbInvFlag: 0,
	delayFlag: 0,
	delayInvFlag: 0,
	pwFlag: 0,
	pwInvFlag: 0,
	data1Flag: 1,
	data2Flag: 0,
	data2SonFlag: 0,
	graphValue: 0,
	dataString: 1,
};
const thirdState = {
	pitchFlag: 1,
	pitchInvFlag: 0,
	pitchQuantFlag: 0,
	amplitudeFlag: 0,
	amplitudeInvFlag: 0,
	amplitudeSusFlag: 0,
	amplitudeModFlag: 0,
	amplitudeModInvFlag: 0,
	wavemixFlag: 0,
	wavemixInvFlag: 0,
	attackFlag: 0,
	attackInvFlag: 0,
	releaseFlag: 0,
	releaseInvFlag: 0,
	clipFlag: 0,
	clipInvFlag: 0,
	noiseFlag: 0,
	noiseType: 0,
	waveForm: 0,
	lpfFlag: 0,
	lpfInvFlag: 0,
	bpfFlag: 0,
	bpfInvFlag: 0,
	hpfFlag: 0,
	hpfInvFlag: 0,
	harmonyFlag: 0,
	harmonyInvFlag: 0,
	chordFlag: 0,
	chordInvFlag: 0,
	reverbFlag: 0,
	reverbInvFlag: 0,
	delayFlag: 0,
	delayInvFlag: 0,
	pwFlag: 0,
	pwInvFlag: 0,
	data1Flag: 1,
	data2Flag: 0,
	data2SonFlag: 0,
	graphValue: 0,
	dataString: 1,
};

const initialState = {
	activeState: 0,
	0: firstState,
	1: secondaryState,
	2: thirdState,
	activeSetting: 1,
};

const reducer = (state = initialState, action) => {
	switch (action.type) {
		case UPDATE_FLAG:
			switch (action.flag) {
				case 'pitchFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							pitchFlag: 1,
							pitchInvFlag: 0,
							pitchQuantFlag: 0,
						},
					};

				case 'pitchInvFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							pitchFlag: 1,
							pitchInvFlag: 1,
							pitchQuantFlag: 0,
						},
					};
				case 'pitchQuantFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							pitchFlag: 0,
							pitchInvFlag: 0,
							pitchQuantFlag: 1,
						},
					};
				case 'bpfFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							bpfFlag: action.val,
							lpfFlag: 0,
							hpfFlag: 0,
						},
					};

				case 'lpfFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							bpfFlag: 0,
							lpfFlag: action.val,
							hpfFlag: 0,
						},
					};
				case 'hpfFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							bpfFlag: 0,
							lpfFlag: 0,
							hpfFlag: action.val,
						},
					};

				case 'harmonyFlag':
					console.log('hello');
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							[action.flag]: action.val,
							chordFlag: 0,
						},
					};
				case 'chordFlag':
					console.log('hello');
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							[action.flag]: action.val,
							harmonyFlag: 0,
						},
					};
				case 'dataString':
					console.log('datastring1');
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],

							dataString: action.val,
						},
					};
				case 'wavemixFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							wavemixFlag: action.val,
							pwFlag: 0,
							clipFlag: 0,
						},
					};
				case 'pwFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							wavemixFlag: 0,
							pwFlag: action.val,
							clipFlag: 0,
						},
					};
				case 'clipFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							wavemixFlag: 0,
							pwFlag: 0,
							clipFlag: action.val,
						},
					};
				case 'attackFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							attackFlag: action.val,
							releaseFlag: 0,
						},
					};
				case 'releaseFlag':
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							attackFlag: 0,
							releaseFlag: action.val,
						},
					};

				default:
					return {
						...state,
						[state.activeState]: {
							...state[state.activeState],
							[action.flag]: action.val,
						},
					};
			}

		case CHANGE_SETTING:
			return {
				...state,
				activeSetting: action.val,
			};
		case CHANGE_PROFILE:
			return {
				...state,
				activeState: action.val,
			};
		default:
			return state;
	}
};

export default reducer;
