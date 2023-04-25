import React, { useState, useEffect, useRef } from 'react';
import {
	LineChart,
	Line,
	BarChart,
	Bar,
	XAxis,
	YAxis,
	Tooltip,
	Legend,
	ResponsiveContainer,
	ReferenceLine,
	Cell,
} from 'recharts';
import { useContext } from 'react';
import WebSocketContext from '../../utils/websocketContext';
import { useDispatch, useSelector } from 'react-redux';
import { updateFlag } from '../../redux/actions';
import play from '../../Images/play.png';
import pause from '../../Images/pause.png';
import forward from '../../Images/forward.png';
import backward from '../../Images/backward.png';
import './graph.css';

const arr = [
	4.8, 5.7, 7.7, 5.8, 6.7, 6.4, 7.3, 6.0, 5.5, 3.6, 5.1, 5.5, 5.6, 5.9, 6.8,
	5.6, 5.1, 4.9, 4.0, 5.4, 5.3, 5.7, 6.5, 5.9, 4.2, 5.2, 6.6, 5.6, 5.7, 5.2,
	5.5, 6.1, 6.1, 5.6, 6.6, 5.0, 4.8, 6.8, 7.1, 6.6, 4.9, 5.5, 4.6, 6.7, 4.5,
	5.5, 5.4, 3.2, 6.4, 5.6, 5.1, 3.8, 6.9, 6.5, 6.0, 4.4, 4.9, 4.8, 6.3, 4.9,
	5.7, 4.2, 6.8, 6.1, 6.1, 5.2, 6.2, 6.2, 4.1, 6.0, 6.5, 6.3, 5.2, 5.1, 7.1,
	5.8, 6.9, 6.5, 6.5, 5.8, 5.8, 6.6, 4.3, 6.5, 5.4, 6.2, 6.6, 5.5, 5.8, 5.2,
	6.7, 6.9, 5.8, 6.7, 7.3, 4.5, 5.7, 5.3, 6.1, 5.4, 6.9, 6.8, 5.2, 5.1, 5.9,
	6.3, 5.8, 5.8, 5.5, 5.8, 7.6, 5.2, 6.7, 6.5, 8.2, 7.0, 7.1, 7.3, 8.1, 7.2,
	4.9, 4.8, 4.6, 7.8, 7.2, 7.0, 6.7, 6.3, 7.1, 8.1, 7.1, 7.0, 5.8, 7.8, 6.4,
	6.2, 5.2, 6.5, 5.9, 7.8, 6.6, 7.6, 5.7, 6.1, 6.8, 5.8, 5.8, 7.1, 6.6, 6.5,
	5.6, 6.9, 7.6, 7.4, 7.7, 8.5, 6.3, 6.5, 6.0, 6.0, 6.1, 6.1, 7.1, 7.6, 7.4,
	4.8, 6.2, 5.0, 7.0, 8.5, 8.4, 7.4, 8.0, 7.1, 7.4, 7.2, 6.5, 7.8, 6.9, 8.3,
	8.5, 7.6, 8.1, 7.8, 7.6, 8.0, 8.5, 8.2, 8.5, 7.7, 6.0, 8.5, 7.2, 7.8, 8.8,
	8.7, 8.2, 8.0, 8.9, 8.6, 9.8,
];

const arr2 = [
	0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0,
	1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0,
	3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 4.0, 4.0, 4.0, 4.0, 4.0,
	4.0, 4.0, 4.0, 4.0, 4.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0,
	6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 7.0, 7.0, 7.0, 7.0, 7.0,
	7.0, 7.0, 7.0, 7.0, 7.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0, 8.0,
	9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 10.0, 10.0, 10.0, 10.0,
	10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 11.0, 11.0, 11.0, 11.0, 11.0, 11.0, 11.0,
	11.0, 11.0, 11.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0,
	13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 14.0, 14.0, 14.0,
	14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0,
];

const data = arr.map((val, index) => {
	return {
		name: index + 1820,
		value: val,
	};
});
const data2 = arr2.map((val, index) => {
	return {
		name: index,
		value: val,
	};
});

const { max } = data.reduce(
	(acc, curr) => {
		if (curr.value > acc.max) {
			acc.max = curr.value;
		}
		if (curr.value < acc.min) {
			acc.min = curr.value;
		}
		return acc;
	},
	{
		max: Number.NEGATIVE_INFINITY,
	}
);
const { max2 } = data2.reduce(
	(acc, curr) => {
		if (curr.value > acc.max) {
			acc.max = curr.value;
		}
		if (curr.value < acc.min) {
			acc.min = curr.value;
		}
		return acc;
	},
	{
		max: Number.NEGATIVE_INFINITY,
	}
);

const roundedMax = Math.ceil(max);
const roundedMax2 = Math.ceil(max2);

const marks = data.map((entry, index) => ({ value: index, label: entry.name }));

const Graph = () => {
	const CurrentGraph = useSelector(
		(state) => state[state.activeState].dataString
	);

	let currentData = CurrentGraph == 1 ? data : data2;
	let currentMax = CurrentGraph == 1 ? roundedMax : roundedMax2;
	const [chartType, setChartType] = useState('line');
	const [selectedDataIndex, setSelectedDataIndex] = useState(
		currentData.length / 2
	);
	const [isPlaying, setIsPlaying] = useState(false);
	const [reverse, setReverse] = useState(true);
	const intervalRef = useRef();
	const ws = useContext(WebSocketContext);
	const state = useSelector((state) => state);
	const dispatch = useDispatch();

	const handleSliderChange = (value) => {
		setSelectedDataIndex(value);
		setIsPlaying(false);
	};

	const handlePlayButtonClick = () => {
		setIsPlaying(!isPlaying);
	};

	const handlePauseButtonClick = () => {
		setIsPlaying(false);
	};

	const handleReverseButtonClick = () => {
		setReverse(!reverse);
		setIsPlaying(true);
	};

	const onMoveMouse = (e) => {
		if (e.isTooltipActive) {
			dispatch(updateFlag('graphValue', e.activeTooltipIndex));
			sendMessage();
			setSelectedDataIndex(e.activeTooltipIndex);
		}
	};

	const onGraphClick = (e) => {
		if (e.activeTooltipIndex) {
			dispatch(updateFlag('graphValue', e.activeTooltipIndex));
			sendMessage();
			setSelectedDataIndex(e.activeTooltipIndex);
		}
	};

	const sendMessage = () => {
		// The message consist of our whole redux state
		const message = {
			dataset: state[state.activeState],
		};

		// Send the message as json to server, using the websocket service
		ws.send(JSON.stringify(message));
	};

	useEffect(() => {
		if (isPlaying) {
			intervalRef.current = setInterval(() => {
				setSelectedDataIndex((prevIndex) =>
					reverse
						? prevIndex === currentData.length - 1
							? 0
							: prevIndex + 1
						: prevIndex === 0
						? currentData.length - 1
						: prevIndex - 1
				);
				dispatch(updateFlag('graphValue', selectedDataIndex));
				sendMessage();
			}, 100);
		} else {
			clearInterval(intervalRef.current);
		}

		return () => clearInterval(intervalRef.current);
	}, [isPlaying, reverse, selectedDataIndex]);

	const renderChart = () => {
		const selectedData = data[selectedDataIndex];
		if (chartType === 'line') {
			return (
				<LineChart
					data={currentData}
					onMouseMove={onMoveMouse}
					onClick={onGraphClick}
				>
					<XAxis
						dataKey='name'
						type='number'
						domain={['dataMin', 'dataMax']}
						tickCount={10}
						tick={{ dy: 10 }}
					/>
					<YAxis
						dataKey='value'
						type='number'
						domain={[0, currentMax]}
						tickCount={10}
						tick={{ dx: -10 }}
						width={100}
					/>
					<Tooltip />
					<Legend verticalAlign='top' align='right' />
					<Line
						type='monotone'
						dataKey='value'
						stroke='green'
						activeDot={{ r: 8 }}
						dot={(props) =>
							selectedDataIndex === props.index ? (
								<svg>
									<circle cx={props.cx} cy={props.cy} r={6} fill='black' />
								</svg>
							) : (
								false
							)
						}
					/>
					{selectedData && (
						<ReferenceLine
							x={selectedData.name}
							strokeDasharray='3 3'
							stroke='black'
						/>
					)}
				</LineChart>
			);
		} else {
			return (
				<BarChart
					data={currentData}
					onMouseMove={(e) => {
						if (e.isTooltipActive) setSelectedDataIndex(e.activeTooltipIndex);
					}}
				>
					<XAxis
						dataKey='name'
						type='number'
						domain={['dataMin', 'dataMax']}
						tickCount={10}
						tick={{ dy: 10 }}
					/>
					<YAxis
						dataKey='value'
						type='number'
						domain={[0, currentMax]}
						tickCount={10}
						tick={{ dx: -10 }}
					/>
					<Tooltip />
					<Legend verticalAlign='top' align='right' />
					<Bar dataKey='value'>
						{currentData.map((entry, index) => (
							<Cell
								key={`cell-${index}`}
								fill={selectedDataIndex === index ? 'blue' : 'gray'}
							/>
						))}
					</Bar>
				</BarChart>
			);
		}
	};
	return (
		<div
			style={{
				flex: 5,
				width: '90%',

				textAlign: 'center',
				fontSize: '24px',
			}}
		>
			<div style={{ display: 'inline-block' }}>
				<div style={autoSound}>
					{/* <button onClick={() => setChartType('line')}>Line Chart</button>
				<button onClick={() => setChartType('bar')}>Bar Chart</button> */}
					<button style={altButton} onClick={() => handleReverseButtonClick()}>
						<img src={backward} style={{ height: '1.5vw', marginLeft: '0' }} />
					</button>
					<div style={playButton} onClick={() => handlePlayButtonClick()}>
						<img
							src={isPlaying ? pause : play}
							style={{ height: '2.5vw', marginLeft: isPlaying ? '19%' : '25%' }}
						/>
					</div>
					<button style={altButton} onClick={() => handleReverseButtonClick()}>
						<img src={forward} style={{ height: '1.5vw', marginLeft: '0%' }} />
					</button>
				</div>
			</div>

			<ResponsiveContainer height='75%' width='95%'>
				{renderChart()}
			</ResponsiveContainer>

			<div
				style={{
					marginTop: '20px',
					width: 'calc(95% - 100px)',
					marginLeft: 100,
					marginRight: 100,
					marginBottom: '5%',
				}}
			>
				<input
					onChange={(e) => handleSliderChange(e.target.value)}
					type='range'
					min='0'
					max={arr.length}
					value={selectedDataIndex}
					className='xslider'
					id='myRange'
				/>
			</div>
		</div>
	);
};

const autoSound = {
	display: 'flex',
	justifyConstent: 'center',
	borderRadius: '50%',
	alignItems: 'center',
	margin: 'auto',
	flexDirection: 'row',
};

const playButton = {
	height: '4vw',
	width: '4vw',
	backgroundColor: '#bbb',
	borderRadius: '50%',
	display: 'flex',
	justifyConstent: 'center',
	alignItems: 'center',
};
const altButton = {
	height: '3vw',
	width: '3vw',
	backgroundColor: '#bbb',
	borderRadius: '50%',
	display: 'inline-block',
	marginLeft: '1vw',
	marginRight: '1vw',
	alignText: 'center',
	border: '0',
};

export default Graph;
