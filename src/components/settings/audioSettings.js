import ButtonGroup from '../buttons/buttonGroup';
import Slider from '../sliders/slider';
import ButtonContainer from '../buttons/buttonContainer';

const AudioSettings = () => {
  const row = {
    display: 'flex',
    flexDirection: 'row',
    width: '100%',
    height: '100%',
  };

  return (
    <div>
      <div
        style={{
          display: 'flex',
          backgroundColor: '#585858',
          flexDirection: 'row',
          height: '100%',
        }}
      >
        <div
          style={{
            display: 'flex',
            width: '15%',
            justifyContent: 'center',
            alignItems: 'center',
            flexDirection: 'column',
          }}
        >
          <ButtonContainer
            backgroudColor={'grey'}
            title='Vågform'
            radius={40}
            flex={1}
          >
            <Slider
              mapIndexToName={{
                0: { name: 'Sinus', id: 'waveForm' },
                1: { name: 'Triangel', id: 'waveForm' },
                2: { name: 'Fyrkant', id: 'waveForm' },
                3: { name: 'Sågtand', id: 'waveForm' },
              }}
            />
          </ButtonContainer>
          <ButtonContainer
            backgroudColor={'grey'}
            title='Tonhöjd'
            radius={40}
            flex={1}
          >
            <Slider
              mapIndexToName={{
                0: { name: 'Frekvens', id: 'pitchFlag' },
                1: { name: 'Speglad frekvens', id: 'pitchInvFlag' },
                2: { name: 'Toner', id: 'pitchQuantFlag' },
              }}
              singleType
            />
          </ButtonContainer>
        </div>
        <div
          style={{
            display: 'flex',
            width: '85%',
            flexDirection: 'column',
            justifyContent: 'center',
            alignItems: 'center',
          }}
        >
          <div style={row}>
            <ButtonContainer backgroudColor={'#FFEEBB'} title='Filter' flex={3}>
              <ButtonGroup
                props={{
                  settings: [
                    { name: 'Lågpass', id: 'lpfFlag', invId: 'lpfInvFlag' },
                    { name: 'Högpass', id: 'hpfFlag', invId: 'hpfInvFlag' },
                    { name: 'Bandpass', id: 'bpfFlag', invId: 'bpfInvFlag' },
                  ],
                  spread: false,
                }}
              />
            </ButtonContainer>
            <ButtonContainer
              backgroudColor={'#FFBBD2'}
              title='Rumseffekt'
              flex={2}
            >
              <ButtonGroup
                props={{
                  settings: [
                    {
                      name: 'Efterklang',
                      id: 'reverbFlag',
                      invId: 'reverbInvFlag',
                    },
                    { name: 'Eko', id: 'delayFlag', invId: 'delayInvFlag' },
                  ],
                  spread: true,
                }}
              />
            </ButtonContainer>
            <ButtonContainer
              backgroudColor={'#A880AF'}
              title='Ljudvolym'
              flex={3}
            >
              <ButtonGroup
                props={{
                  settings: [
                    {
                      name: 'Ljudvolym',
                      id: 'amplitudeFlag',
                      invId: 'amplitudeInvFlag',
                    },
                    {
                      name: 'Modulation',
                      id: 'amplitudeModFlag',
                      invId: 'amplitudeModInvFlag',
                    },
                    {
                      name: 'Sustain',
                      id: 'amplitudeSusFlag',
                      invId: undefined,
                    },
                  ],
                  spread: true,
                }}
              />
            </ButtonContainer>
            <div
              style={{
                display: 'flex',
                width: '10%',
                justifyContent: 'center',
                alignContent: 'center',
              }}
            >
              <div>
                <button>Återställ</button>
              </div>
            </div>
          </div>
          <div style={row}>
            <ButtonContainer
              backgroudColor={'#FFBCA7'}
              title='Harmoni'
              flex={2}
            >
              <ButtonGroup
                props={{
                  settings: [
                    {
                      name: 'Harmoni',
                      id: 'harmonyFlag',
                      invId: 'harmonyInvFlag',
                    },
                    {
                      name: 'Dur & moll',
                      id: 'chordFlag',
                      invId: 'chordInvFlag',
                    },
                  ],
                  spread: false,
                }}
              />
            </ButtonContainer>
            <ButtonContainer backgroudColor={'#FB9891'} title='Brus' flex={3}>
              <ButtonGroup
                props={{
                  settings: [
                    {
                      name: 'Vitt brus',
                      id: 'noiseFlag',
                      invId: 'noiseInvFlag',
                      type: 'noiseType',
                      val: 0,
                    },
                    {
                      name: 'Knaster',
                      id: 'noiseFlag',
                      invId: 'noiseInvFlag',
                      type: 'noiseType',
                      val: 1,
                    },
                    {
                      name: 'Rosa brus',
                      id: 'noiseFlag',
                      invId: 'harmonyInvFlag',
                      type: 'noiseType',
                      val: 2,
                    },
                  ],
                  spread: true,
                }}
              />
            </ButtonContainer>
            <ButtonContainer
              backgroudColor={'#F28880'}
              title='Tidaspekter'
              flex={2}
            >
              <ButtonGroup
                props={{
                  settings: [
                    {
                      name: 'Attack',
                      id: 'attackFlag',
                      invId: 'attackInvFlag',
                    },
                    {
                      name: 'Release',
                      id: 'releaseFlag',
                      invId: 'releaseInvFlag',
                    },
                  ],
                  spread: false,
                }}
              />
            </ButtonContainer>
            <ButtonContainer
              backgroudColor={'#9ED1F9'}
              title='Klangfärg'
              flex={3}
            >
              <ButtonGroup
                props={{
                  settings: [
                    {
                      name: 'Vågform',
                      id: 'wavemixFlag',
                      invId: 'wavemixInvFlag',
                    },
                    {
                      name: 'Pulsbredd',
                      id: 'pwFlag',
                      invId: 'pwInvFlag',
                    },
                    {
                      name: 'Distortion',
                      id: 'clipFlag',
                      invId: 'clipInvFlag',
                    },
                  ],
                  spread: false,
                }}
              />
            </ButtonContainer>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AudioSettings;
