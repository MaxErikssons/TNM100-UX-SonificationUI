import './ioButton.css';
import IoIcon from '../SVGS/ioIcon';
import { useSelector, useDispatch } from 'react-redux';
import { updateFlag } from '../../redux/actions';

const Button = ({ setting, isFirst, isLast }) => {
  const buttonActive = useSelector(
    (state) => state[state.activeState][setting.id]
  );
  const inverseActive = useSelector(
    (state) => state[state.activeState][setting.invId]
  );
  const dispatch = useDispatch();

  //Style the borders depending on position of button
  const getButtonStyles = () => {
    return {
      borderLeft: !isFirst && 'gray solid 1px',
      borderTopLeftRadius: isFirst && '15px',
      borderBottomLeftRadius: isFirst && '15px',
      borderTopRightRadius: isLast && '15px',
      borderBottomRightRadius: isLast && '15px',
    };
  };

  //Change color of button if (in)active.
  const activeStyle = () => {
    if (buttonActive) {
      return {
        backgroundColor: '#C7C7C7',
        boxShadow: 'none',
      };
    } else {
      return { backgroundColor: '#D9D9D9', boxShadow: '0px 4px 0px #6A6969' };
    }
  };
  return (
    <div
      style={{
        width: '100%',
      }}
      onClick={() => {
        dispatch(updateFlag(setting.id, Number(!buttonActive)));
        if (setting.type) {
          dispatch(updateFlag(setting.type, Number(setting.val)));
        }
      }}
    >
      <div style={{ height: '100%' }}>
        <div style={{ fontSize: 12 }}>{setting?.name}</div>
        <div
          style={{
            ...getButtonStyles(),
            ...activeStyle(),
            padding: '5%',
          }}
        >
          <div
            class='mainbutton'
            style={{ borderColor: inverseActive ? 'white' : 'black' }}
          >
            <div
              class='topBorder'
              style={{ borderColor: inverseActive ? 'black' : 'white' }}
            ></div>

            <IoIcon
              id='ioicon'
              color={buttonActive ? '#00FF00' : '#000000'}
            ></IoIcon>
          </div>
          {Boolean(buttonActive) && setting.invId && (
            <div
              className='mirrorbutton'
              role='button'
              aria-pressed='false'
              onClick={(e) => {
                e.stopPropagation();
                dispatch(updateFlag(setting.invId, Number(!inverseActive)));
              }}
            >
              Inverse
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Button;
