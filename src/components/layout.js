import Settings from './settings/settings';
import Graph from './graph/graph';

const Layout = () => {
  const container = {
    display: 'flex',
    flexDirection: 'column',
    height: '100vh',
    width: '100%',
  };

  return (
    <div style={container}>
      <Graph />
      <Settings />
    </div>
  );
};

export default Layout;
