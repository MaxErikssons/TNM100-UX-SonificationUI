import React, { useState } from 'react';
import { changeProfile } from '../../redux/actions';
import { useDispatch, useSelector } from 'react-redux';

// const IoButton = ({ id, invId, color }) => {
//   const [orientation, setOrientation] = useState(false);
//   const dispatch = useDispatch();
//   console.log(id);
//   console.log(invId);

//   function handleRing(e) {
//     e.stopPropagation();
//     setOrientation(orientation ? false : true);
//   }

//   const toggle = (e) => {
//     // Example of how we can set a flag
//     // Takes in the variable name and 0 or 1 (on/off)
//     dispatch(updateFlag(id, e));
//     dispatch(updateFlag(invId, e));
//   };

const ProfileMenu = ({ active }) => {
  const current = useSelector((state) => state.activeState);
  const dispatch = useDispatch();
  const handleClick = (e) => {
    dispatch(changeProfile(e));
  };
  return (
    <div style={menuStyle}>
      <div
        style={current == 0 ? activeButton : profileButton}
        onClick={() => handleClick(0)}
      >
        <p>1</p>
      </div>
      <div
        style={current == 1 ? activeButton : profileButton}
        onClick={() => handleClick(1)}
      >
        <p>2</p>
      </div>
      <div
        style={current == 2 ? activeButton : profileButton}
        onClick={() => handleClick(2)}
      >
        <p>3</p>
      </div>
    </div>
  );
};

const menuStyle = {
  display: 'flex',
  justifyContent: 'center',
  flexDirection: 'column',
  with: '10vw',
  marginTop: '1vw',
};

const profileButton = {
  justifyContent: 'center',
  textAlign: 'center',
  lineHeight: '2vw',
  display: 'block',
  height: '6vw',
  width: '6vw',
  backgroundColor: '#A7A7A7',
  borderRadius: '10%',
  marginBottom: '-1vw',
  fontSize: '40px',
  marginTop: '0px',
};

const activeButton = {
  justifyContent: 'center',
  textAlign: 'center',
  lineHeight: '2vw',
  display: 'block',
  height: '6vw',
  width: '6vw',
  backgroundColor: '#C7C7C7',
  borderRadius: '10%',
  marginBottom: '-1vw',
  fontSize: '40px',
  zIndex: '20000',
  marginTop: '0px',
};

export default ProfileMenu;
