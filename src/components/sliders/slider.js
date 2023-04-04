import 'react-responsive-carousel/lib/styles/carousel.min.css'; // requires a loader
import { Carousel } from 'react-responsive-carousel';
import { useState } from 'react';

const Slider = ({ props }) => {
  const [index, setIndex] = useState(0);

  const mapIndexToName = {
    0: 'Sågtand',
    1: 'Sinus',
    2: 'Fyrkant',
  };

  const listLength = 3;
  const height = 60;
  const arrowHeight = 25;
  const arrowWidth = 20;

  const handlePrev = () => {
    const newIndex = index === 0 ? listLength - 1 : index - 1;
    setIndex(newIndex);
  };

  const handleNext = () => {
    const newIndex = index === listLength - 1 ? 0 : index + 1;
    setIndex(newIndex);
  };
  return (
    <div style={{ flex: 1 }}>
      <div style={row}>
        <div
          onClick={handlePrev}
          style={{
            ...btnStyles,
            height: height,
            marginRight: '10%',
          }}
        >
          <div>
            <img
              alt=''
              src={require('../../assets/arrow.png')}
              width={arrowWidth}
              height={arrowHeight}
            />
          </div>
        </div>
        <Carousel
          onChange={(e) => console.log(mapIndexToName[e])}
          showArrows={false}
          showThumbs={false}
          showIndicators={false}
          showStatus={false}
          selectedItem={index}
        >
          <div
            style={{
              height,
            }}
          >
            <img
              src={require('../../assets/sawtooth.png')}
              height={height}
              alt=''
            />
          </div>

          <div
            style={{
              height: height,
            }}
          >
            <img
              src={require('../../assets/sawtooth.png')}
              height={height}
              alt=''
            />
          </div>

          <div
            style={{
              height: height,
            }}
          >
            <img
              src={require('../../assets/sawtooth.png')}
              height={height}
              alt=''
            />
          </div>
        </Carousel>
        <div
          onClick={handleNext}
          style={{
            ...btnStyles,
            height: height,
            marginLeft: '10%',
          }}
        >
          <div>
            <img
              src={require('../../assets/arrow-reverse.png')}
              width={arrowWidth}
              height={arrowHeight}
              alt=''
            />
          </div>
        </div>
      </div>
      <div style={header}>{mapIndexToName[index]}</div>
    </div>
  );
};

const btnStyles = {
  cursor: 'pointer',
  justifyContent: 'center',
  alignItems: 'center',
  display: 'flex',
  width: '100%',
};

const header = {
  fontWeight: 'bold',
  color: 'white',
  marginTop: '2%',
};

const row = { display: 'flex', flexDirection: 'row' };

export default Slider;
