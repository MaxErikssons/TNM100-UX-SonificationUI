import './ioButton.css';
import IoIcon from '../SVGS/ioIcon';
import { useState } from 'react';
import React from 'react';
import { useDispatch } from 'react-redux';
import { updateFlag } from '../../redux/actions';

const IoButton = ({ id, invId, color }) => {
  const [orientation, setOrientation] = useState(false);
  const dispatch = useDispatch();
  console.log(id);
  console.log(invId);

  function handleRing(e) {
    e.stopPropagation();
    setOrientation(orientation ? false : true);
  }

  const toggle = (e) => {
    // Example of how we can set a flag
    // Takes in the variable name and 0 or 1 (on/off)
    dispatch(updateFlag(id, e));
    dispatch(updateFlag(invId, e));
  };

  return (
    <div
      style={{
        margin: 'auto',
        display: 'block',
        position: 'relative',
        top: '18%',
        height: '50px',
      }}
    >
      <div
        class='mainbutton'
        style={{ borderColor: orientation ? 'white' : 'black' }}
      >
        <div
          class='topBorder'
          style={{ borderColor: orientation ? 'black' : 'white' }}
        ></div>
        <IoIcon id='ioicon' color={color}></IoIcon>
      </div>
      {color === '#00FF00' && (
        <div
          className='mirrorbutton'
          role='button'
          aria-pressed='false'
          onClick={(e) => handleRing(e)}
        ></div>
      )}
    </div>
  );
};

export default IoButton;
