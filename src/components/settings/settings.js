import { useState } from 'react';
import ButtonGroup from '../buttons/buttonGroup';
import Slider from '../sliders/slider';
import ButtonContainer from '../buttons/buttonContainer';
import ButtonSpread from '../buttons/buttonSpread';

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
        <div style={{ width: '25%' }}>
          <ButtonContainer backgroudColor={'grey'} title='Vågform'>
            <Slider props={{ header: 'Vågform' }} />
          </ButtonContainer>
        </div>
        <div
          style={{
            display: 'flex',
            width: '75%',
            flexDirection: 'column',
          }}
        >
          <div style={row}>
            <ButtonContainer backgroudColor={'#FFEEBB'} title='Filter'>
              <ButtonGroup
                props={{
                  header: 'Filter',
                  settings: [
                    { name: 'Lågpass', id: 'lpfFlag', invId: 'lpfInvFlag' },
                    { name: 'Högpass', id: 'hpfFlag', invId: 'hpfInvFlag' },
                    { name: 'Bandpass', id: 'bpfFlag', invId: 'bpfInvFlag' },
                  ],
                  background: '#FFEEBB',
                  spread: false,
                }}
              />
            </ButtonContainer>
            <ButtonContainer backgroudColor={'#FFBBD2'} title='Rumseffekt'>
              <ButtonGroup
                props={{
                  header: 'Rumseffekt',
                  settings: [
                    {
                      name: 'Efterklang',
                      id: 'reverbFlag',
                      invId: 'reverbInvFlag',
                    },
                    { name: 'Eko', id: 'delayFlag', invId: 'delayInvFlag' },
                  ],
                  background: '#FFBBD2',
                  spread: true,
                }}
              />
            </ButtonContainer>

            <ButtonContainer backgroudColor={'#FFBCA7'} title='Ljudvolum'>
              <ButtonGroup
                props={{
                  header: 'Harmoni',
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
                  background: '#FFBCA7',
                  spread: false,
                }}
              />
            </ButtonContainer>
          </div>
          <div style={row}>
            <ButtonContainer backgroudColor={'#FFBCA7'} title='Ljudvolum'>
              <ButtonGroup
                props={{
                  header: 'Brus',
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
                      name: 'Vitt brus',
                      id: 'noiseFlag',
                      invId: 'harmonyInvFlag',
                      type: 'noiseType',
                      val: 2,
                    },
                  ],
                  background: '#FFBCA7',
                  spread: true,
                }}
              />
            </ButtonContainer>
            {/* <ButtonContainer backgroudColor={'#FFBCA7'} title='Harmoni'>
              <ButtonGroup
                props={{
                  header: 'Klangfärg',
                  settings: [],
                  background: '#FFBCA7',
                }}
              />
            </ButtonContainer>
              
            <ButtonContainer backgroudColor={'#FFEEBB'} title='Brus'>
              <ButtonGroup
                props={{
                  header: 'Filter',
                  settings: ['Lågpass', 'Högpass', 'Bandpass'],
                  background: '#FFEEBB',
                }}
              />
            </ButtonContainer>
            <ButtonContainer backgroudColor={'#FFEEBB'} title='Tidsaspekter'>
              <ButtonGroup
                props={{
                  header: 'Filter',
                  settings: ['Lågpass', 'Högpass', 'Bandpass'],
                  background: '#FFEEBB',
                }}
              />
            </ButtonContainer>
            <ButtonContainer backgroudColor={'#FFBCA7'} title='Klangfärg'>
              <ButtonGroup
                props={{
                  header: 'Setting 3',
                  settings: ['Set 1', 'Set 2'],
                  background: '#FFBCA7',
                }}
              />
            </ButtonContainer>
              */}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Settings;
