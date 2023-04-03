import './settings.css';
import { useState } from 'react';
import Button from '../buttons/button';
import Slider from '../sliders/slider';

const Settings = () => {
  const [activeSetting, setActiveSetting] = useState(1);

  const getActiveSetting = (index) => {
    if (activeSetting === index) {
      return { backgroundColor: '#585858' };
    } else {
      return { backgroundColor: '#343232' };
    }
  };

  return (
    <div>
      <div className='settingsBar'>
        <div className='settingsHeader' style={getActiveSetting(1)}>
          Ljudinställning
        </div>
        <div className='settingsHeader' style={getActiveSetting(2)}>
          Grafinställning
        </div>
        <div className='settingsHeader' style={getActiveSetting(3)}>
          Förinställningar
        </div>
      </div>
      <div className='settingsArea'>
        <div className='settingsAreaDivided'>
          <div style={{ flex: 1 }}>
            <Slider props={{ header: 'Vågform' }} />
          </div>
          <div style={{ flex: 1 }}>
            <Button
              props={{
                header: 'Filter',
                settings: ['Lågpass', 'Högpass', 'Bandpass'],
                background: '#FFEEBB',
                spread: false,
              }}
            />
          </div>
          <div style={{ flex: 1 }}>
            <Button
              props={{
                header: 'Rumseffekt',
                settings: ['Set 1', 'Set 2', 'Set 3'],
                background: '#FFBBD2',
                spread: true,
              }}
            />
          </div>
          <div style={{ flex: 1 }}>
            <Button
              props={{
                header: 'Setting 3',
                settings: ['Set 1', 'Set 2'],
                background: '#FFBCA7',
                spread: false,
              }}
            />
          </div>
        </div>
        <div className='settingsAreaDivided' style={{ top: '50%' }}>
          <div style={{ flex: 1 }}>
            <Button
              props={{
                header: 'Setting 3',
                settings: ['Set 1', 'Set 2'],
                background: '#FB9891',
                spread: true,
              }}
            />
          </div>
        </div>
      </div>
    </div>
  );
};

export default Settings;
