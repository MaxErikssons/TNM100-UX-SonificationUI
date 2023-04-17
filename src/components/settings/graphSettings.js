import Slider from '../sliders/slider';
import ButtonContainer from '../buttons/buttonContainer';

const GraphSettings = () => {
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
        ></div>
      </div>
    </div>
  );
};

export default GraphSettings;
