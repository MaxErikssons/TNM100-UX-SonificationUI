import { UPDATE_FLAG } from './actions';

const initialState = {
  pitchFlag: 0,
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
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case UPDATE_FLAG:
      switch (action.flag) {
        case 'pitchFlag':
          return {
            ...state,
            pitchFlag: 1,
            pitchInvFlag: 0,
            pitchQuantFlag: 0,
          };

        case 'pitchInvFlag':
          return {
            ...state,
            pitchFlag: 0,
            pitchInvFlag: 1,
            pitchQuantFlag: 0,
          };
        case 'pitchQuantFlag':
          return {
            ...state,
            pitchFlag: 0,
            pitchInvFlag: 0,
            pitchQuantFlag: 1,
          };
        default:
          return {
            ...state,
            [action.flag]: action.val,
          };
      }

    default:
      return state;
  }
};

export default reducer;
