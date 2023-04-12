import { useState } from 'react';
import ButtonGroup from '../buttons/buttonGroup';
import Slider from '../sliders/slider';
import ButtonContainer from '../buttons/buttonContainer';

const Settings = () => {
  const [activeSetting, setActiveSetting] = useState(1);

  const getActiveSetting = (index) => {
    return {
      backgroundColor: activeSetting === index ? '#585858' : '#343232',
      flex: 1,
      textAlign: 'center',
      color: 'white',
      fontSize: 18,
      fontWeight: '600',
      borderRight: '1px solid',
      borderColor: '#585858',
    };
  };

  const bar = {
    display: 'flex',
    flexDirection: 'row',
  };

  const row = {
    display: 'flex',
    flexDirection: 'row',
    width: '100%',
    border: 'solid',
  };

  return (
    <div>
      <div style={bar}>
        <div style={getActiveSetting(1)}>Ljudinställning</div>
        <div style={getActiveSetting(2)}>Grafinställning</div>
        <div style={getActiveSetting(3)}>Förinställningar</div>
      </div>
      <div
        style={{
          display: 'flex',
          backgroundColor: '#585858',
          flexDirection: 'row',
          padding: '1%',
        }}
      >
        <div
          style={{
            display: 'flex',
            width: '15%',
            justifyContent: 'center',
            flexDirection: 'column',
            border: 'solid',
          }}
        >
          <ButtonContainer backgroudColor={'grey'} title='Vågform' radius={40}>
            <Slider
              mapIndexToName={{
                0: { name: 'Sinus', id: 'waveForm' },
                1: { name: 'Triangel', id: 'waveForm' },
                2: { name: 'Fyrkant', id: 'waveForm' },
                3: { name: 'Sågtand', id: 'waveForm' },
              }}
            />
          </ButtonContainer>
          <ButtonContainer backgroudColor={'grey'} title='Tonhöjd' radius={40}>
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
            <ButtonContainer backgroudColor={'#FFEEBB'} title='Filter'>
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
            <ButtonContainer backgroudColor={'#FFBBD2'} title='Rumseffekt'>
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
            <ButtonContainer backgroudColor={'#A880AF'} title='Ljudvolym'>
              <ButtonGroup
                props={{
                  settings: [
                    {
                      name: 'Ljudvolym',
                      id: '',
                      invId: '',
                    },
                    { name: 'Modulation', id: '', invId: '' },
                    { name: 'Sustain', id: '', invId: undefined },
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
                border: 'solid',
              }}
            >
              <div>
                <button>Återställ</button>
              </div>
            </div>
          </div>
          <div style={row}>
            <ButtonContainer backgroudColor={'#FFBCA7'} title='Harmoni'>
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
            <ButtonContainer backgroudColor={'#FB9891'} title='Brus'>
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
            <ButtonContainer backgroudColor={'#F28880'} title='Tidaspekter'>
              <ButtonGroup
                props={{
                  settings: [
                    {
                      name: 'Attack',
                      id: '',
                      invId: '',
                    },
                    {
                      name: 'Release',
                      id: '',
                      invId: '',
                    },
                  ],
                  spread: false,
                }}
              />
            </ButtonContainer>
            <ButtonContainer backgroudColor={'#9ED1F9'} title='Klangfärg'>
              <ButtonGroup
                props={{
                  settings: [
                    {
                      name: 'Vågform',
                      id: '',
                      invId: '',
                    },
                    {
                      name: 'Pulsbredd',
                      id: '',
                      invId: '',
                    },
                    {
                      name: 'Distortion',
                      id: '',
                      invId: '',
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

export default Settings;
