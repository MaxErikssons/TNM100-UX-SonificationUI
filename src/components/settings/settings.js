import { useState } from 'react';
import Button from '../buttons/button';
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
              <Button
                props={{
                  header: 'Filter',
                  settings: ['Lågpass', 'Högpass', 'Bandpass'],
                  background: '#FFEEBB',
                  spread: false,
                }}
              />
            </ButtonContainer>
            <ButtonContainer backgroudColor={'#FFBBD2'} title='Rumseffekt'>
              <Button
                props={{
                  header: 'Rumseffekt',
                  settings: ['Set 1', 'Set 2', 'Set 3'],
                  background: '#FFBBD2',
                  spread: true,
                }}
              />
            </ButtonContainer>
            <ButtonContainer backgroudColor={'#FFBCA7'} title='Ljudvolum'>
              <Button
                props={{
                  header: 'Setting 3',
                  settings: ['Set 1', 'Set 2'],
                  background: '#FFBCA7',
                  spread: false,
                }}
              />
            </ButtonContainer>
          </div>
          <div style={row}>
            <ButtonContainer backgroudColor={'#FFBCA7'} title='Harmoni'>
              <Button
                props={{
                  header: 'Setting 3',
                  settings: ['Set 1', 'Set 2'],
                  background: '#FFBCA7',
                  spread: false,
                }}
              />
            </ButtonContainer>
            <ButtonContainer backgroudColor={'#FFEEBB'} title='Brus'>
              <Button
                props={{
                  header: 'Filter',
                  settings: ['Lågpass', 'Högpass', 'Bandpass'],
                  background: '#FFEEBB',
                  spread: false,
                }}
              />
            </ButtonContainer>
            <ButtonContainer backgroudColor={'#FFEEBB'} title='Tidsaspekter'>
              <Button
                props={{
                  header: 'Filter',
                  settings: ['Lågpass', 'Högpass', 'Bandpass'],
                  background: '#FFEEBB',
                  spread: false,
                }}
              />
            </ButtonContainer>
            <ButtonContainer backgroudColor={'#FFBCA7'} title='Klangfärg'>
              <Button
                props={{
                  header: 'Setting 3',
                  settings: ['Set 1', 'Set 2'],
                  background: '#FFBCA7',
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
