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
import Slider from 'rc-slider';
import 'rc-slider/assets/index.css';
import { useContext } from 'react';
import WebSocketContext from '../../utils/websocketContext';
import { useDispatch, useSelector } from 'react-redux';
import { updateFlag } from '../../redux/actions';

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

const data = arr.map((val, index) => {
  return {
    name: index + 1820,
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

const roundedMax = Math.ceil(max);

const marks = data.map((entry, index) => ({ value: index, label: entry.name }));

const Graph = () => {
  const [chartType, setChartType] = useState('line');
  const [selectedDataIndex, setSelectedDataIndex] = useState(data.length / 2);
  const [isPlaying, setIsPlaying] = useState(false);
  const [reverse, setReverse] = useState(false);
  const intervalRef = useRef();
  const ws = useContext(WebSocketContext);
  const state = useSelector((state) => state);
  const dispatch = useDispatch();

  const handleSliderChange = (value) => {
    setSelectedDataIndex(value);
    setIsPlaying(false);
  };

  const handlePlayButtonClick = () => {
    setIsPlaying(true);
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
      // sendMessage();
      setSelectedDataIndex(e.activeTooltipIndex);
    }
  };

  const onGraphClick = (e) => {
    console.log(e.activePayload[0].value);
    dispatch(updateFlag('graphVal', e.activePayload[0].value));
    sendMessage();
    setSelectedDataIndex(e.activeTooltipIndex);
  };

  const formatXAxisTicks = (value) => {
    return Math.round(value / 10) * 10;
  };

  const sendMessage = () => {
    // The message consist of our whole redux state
    const message = {
      dataset: state,
    };

    // Send the message as json to server, using the websocket service
    ws.send(JSON.stringify(message));
  };

  useEffect(() => {
    if (isPlaying) {
      intervalRef.current = setInterval(() => {
        setSelectedDataIndex((prevIndex) =>
          reverse
            ? prevIndex === data.length - 1
              ? 0
              : prevIndex + 1
            : prevIndex === 0
            ? data.length - 1
            : prevIndex - 1
        );
      }, 300);
    } else {
      clearInterval(intervalRef.current);
    }

    return () => clearInterval(intervalRef.current);
  }, [isPlaying, reverse]);

  const renderChart = () => {
    const selectedData = data[selectedDataIndex];
    if (chartType === 'line') {
      return (
        <LineChart data={data} onMouseMove={onMoveMouse} onClick={onGraphClick}>
          <XAxis
            dataKey='name'
            type='number'
            domain={['dataMin', 'dataMax']}
            tickCount={10}
          />
          <YAxis
            dataKey='value'
            type='number'
            domain={[0, roundedMax]}
            tickCount={10}
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
          data={data}
          onMouseMove={(e) => {
            if (e.isTooltipActive) setSelectedDataIndex(e.activeTooltipIndex);
          }}
        >
          <XAxis
            dataKey='name'
            type='number'
            domain={['dataMin', 'dataMax']}
            tickCount={10}
          />
          <YAxis
            dataKey='value'
            type='number'
            domain={[0, roundedMax]}
            tickCount={10}
          />
          <Tooltip />
          <Legend verticalAlign='top' align='right' />
          <Bar dataKey='value'>
            {data.map((entry, index) => (
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
        flex: 1,
        width: '80%',
        height: '70%',
        marginLeft: 'auto',
        marginRight: 'auto',
        textAlign: 'center',
        fontSize: '24px',
      }}
    >
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
        }}
      >
        <button onClick={() => setChartType('line')}>Line Chart</button>
        <button onClick={() => setChartType('bar')}>Bar Chart</button>
        <button onClick={() => handlePlayButtonClick()}>Play</button>
        <button onClick={() => handlePauseButtonClick()}>Pause</button>
        <button onClick={() => handleReverseButtonClick()}>Reverse</button>
      </div>

      <ResponsiveContainer height={'87%'}>{renderChart()}</ResponsiveContainer>

      <div
        style={{
          marginTop: '20px',
          width: '95%',
          marginLeft: '5%',
          marginBottom: '5%',
        }}
      >
        <Slider
          min={0}
          max={data.length - 1}
          //marks={marks} //Uncomment to display marks on the slider
          step={1}
          onChange={handleSliderChange}
          draggableTrack={true}
          value={selectedDataIndex}
          railStyle={{
            backgroundColor: 'gray', // Change the color of the rail
          }}
          trackStyle={{
            backgroundColor: 'gray', // Change the color of the track
          }}
          handleStyle={{
            borderColor: 'purple', // Change the color of the circle inside the slider
            backgroundColor: 'orange', // Change the background color of the circle inside the slider
          }}
        />
      </div>
    </div>
  );
};

export default Graph;
