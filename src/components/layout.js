import Settings from './settings/settings';
import Graph from './graph/graph';
import { useContext } from 'react';
import WebSocketContext from '../utils/websocketContext';
import { useDispatch, useSelector } from 'react-redux';
import { updateFlag } from '../redux/actions';

const Layout = () => {
  const container = {
    display: 'flex',
    flexDirection: 'column',
    height: '100vh',
    width: '100%',
    backgroundColor: '#DBDBDB',
  };

  const ws = useContext(WebSocketContext);
  const dispatch = useDispatch();
  const state = useSelector((state) => state);

  const sendMessage = () => {
    // The message consist of our whole redux state
    const message = {
      dataset: state,
    };

    // Send the message as json to server, using the websocket service
    ws.send(JSON.stringify(message));
  };

  const toggle = () => {
    // Example of how we can set a flag
    // Takes in the variable name and 0 or 1 (on/off)
    dispatch(updateFlag('amplitudeFlag', 1));
  };

  return (
    <div style={container}>
      <Graph />
      <Settings />
    </div>
  );
};

export default Layout;
