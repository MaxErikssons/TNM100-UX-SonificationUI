import GraphSettings from './graphSettings';
import AudioSettings from './audioSettings';
import { useSelector, useDispatch } from 'react-redux';
import { changeSetting } from '../../redux/actions';
const Setting = () => {
  const activeSetting = useSelector((state) => state.activeSetting);
  const dispatch = useDispatch();

  const settingStyles = (index) => {
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

  const getActiveSetting = () => {
    switch (activeSetting) {
      case 1:
        return <AudioSettings />;
      case 2:
        return <GraphSettings />;
      default:
        return <AudioSettings />;
    }
  };

  const bar = {
    display: 'flex',
    flexDirection: 'row',
  };

  return (
    <div style={{ flex: 3 }}>
      <div style={bar}>
        <button
          style={settingStyles(1)}
          onClick={() => dispatch(changeSetting(1))}
        >
          Ljudinställning
        </button>
        <button
          style={settingStyles(2)}
          onClick={() => dispatch(changeSetting(2))}
        >
          Grafinställning
        </button>
      </div>
      {getActiveSetting()}
    </div>
  );
};

export default Setting;
