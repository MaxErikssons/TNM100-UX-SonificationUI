import './button.css';
import { useState } from 'react';

const Button = ({ props }) => {
  const { header, settings, background, spread } = props;
  const [buttonClicked, setButtonClicked] = useState(2);

  const getButtonStyles = (index) => {
    if (spread) {
      return { ...getActiveButton(index + 1), borderRadius: '10px' };
    }

    const isFirst = index + 1 === 1;
    const isLast = index + 1 === settings.length;

    return {
      ...getActiveButton(index + 1),
      borderLeft: !isFirst && 'black solid 1px',
      borderTopLeftRadius: isFirst && '15px',
      borderBottomLeftRadius: isFirst && '15px',
      borderTopRightRadius: isLast && '15px',
      borderBottomRightRadius: isLast && '15px',
    };
  };

  const getActiveButton = (index) => {
    if (buttonClicked === index) {
      return {
        backgroundColor: '#C7C7C7',
        boxShadow: 'none',
      };
    } else {
      return -{ background: '#D9D9D9', boxShadow: '0px 4px 0px #6A6969' };
    }
  };

  return (
    <div
      className='settingContainer'
      style={{ width: settings.length * 5 + '%' }}
    >
      <div className='buttonHeader'>{header}</div>
      <div className='settingContent' style={{ background: background }}>
        <div className='buttonContainer'>
          {settings.map((setting, index) => (
            <div
              key={index}
              className='buttonContent'
              style={{
                marginLeft: spread && '10px',
                marginRight: spread && '10px',
              }}
            >
              <div>{setting}</div>
              <div className='button' style={getButtonStyles(index)}></div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Button;
