import Slider from '../sliders/slider';
import ButtonContainer from '../buttons/buttonContainer';

const GraphSettings = () => {
	const height = 100;
	return (
		<div>
			<div
				style={{
					display: 'flex',
					backgroundColor: '#585858',
					flexDirection: 'row',
					height: '100%',
				}}
			>
				<div
					style={{
						display: 'flex',
						width: '15%',
						justifyContent: 'center',
						alignItems: 'center',
						flexDirection: 'row',
					}}
				>
					<ButtonContainer
						backgroudColor={'grey'}
						title='Vågform'
						radius={40}
						flex={1}
					>
						<Slider
							mapIndexToName={{
								0: { name: 'Graph', id: 'waveForm' },
								1: { name: 'Triangel', id: 'waveForm' },
							}}
						>
							<div
								style={{
									height,
								}}
							>
								<img
									src={require('../../assets/sinus.png')}
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
						</Slider>
					</ButtonContainer>
					<ButtonContainer
						backgroudColor={'grey'}
						title='Tonhöjd'
						radius={40}
						flex={1}
					>
						<Slider
							mapIndexToName={{
								0: { name: 'Frekvens', id: 'pitchFlag' },
								1: { name: 'Speglad frekvens', id: 'pitchInvFlag' },
								2: { name: 'Toner', id: 'pitchQuantFlag' },
							}}
							singleType
						/>
					</ButtonContainer>

					<ButtonContainer
						backgroudColor={'grey'}
						title='Vågform'
						radius={40}
						flex={1}
					>
						<Slider
							mapIndexToName={{
								0: { name: 'Data1', id: 'dataString' },
								1: { name: 'Data2', id: 'dataString' },
							}}
						>
							<div
								style={{
									height,
								}}
							>
								<img
									src={require('../../assets/sinus.png')}
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
						</Slider>
					</ButtonContainer>
				</div>
				<div
					style={{
						display: 'flex',
						width: '85%',
						flexDirection: 'column',
						justifyContent: 'center',
						alignItems: 'center',
					}}
				></div>
			</div>
		</div>
	);
};

export default GraphSettings;
