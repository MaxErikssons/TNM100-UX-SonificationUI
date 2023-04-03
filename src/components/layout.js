import Settings from './settings/settings';
import Graph from './graph/graph';

const Layout = () => {
  const container = {
    background: '#DBDBDB',
    width: '100%',
    height: '61%',
    position: 'absolute',
  };

  return (
    <div>
      <div style={container}>
        <Graph />
      </div>
      <Settings />
    </div>
  );
};

export default Layout;
