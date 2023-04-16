import Settings from './settings/settings';
import Graph from './graph/graph';
import ProfileMenu from './profiles/profileMenu';

const Layout = () => {
	const container = {
		display: 'flex',
		flexDirection: 'column',
		height: '100vh',
		width: '100%',
		backgroundColor: '#DBDBDB',
	};

	return (
		<div style={container}>
			<div style={{ background: 'orange', flex: 1 }}>
				<div style={{ fontWeight: 'bold', fontSize: 24 }}>
					UTFORSKA SONIFIERING
				</div>
				<text>
					Lorem Ipsum is simply dummy text of the printing and typesetting
					industry. Lorem Ipsum has been the industry's standard dummy text ever
					since the 1500s, when an unknown printer took a galley of type and
					scrambled it to make a type specimen book. It has survived not only
					five centuries, but also the leap into electronic typesetting,
					remaining essentially unchanged. It was popularised in the 1960s with
					the release of Letraset sheets containing Lorem Ipsum passages, and
					more recently with desktop publishing software like Aldus PageMaker
					including versions of Lorem Ipsum
				</text>
			</div>
			<div style={{ display: 'flex' }}>
				<Graph />
				<ProfileMenu active={2} />
			</div>

			<Settings />
		</div>
	);
};

export default Layout;
