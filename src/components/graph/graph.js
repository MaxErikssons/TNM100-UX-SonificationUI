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

const data = [
  { name: 'Jan', value: 300 },
  { name: 'Feb', value: 200 },
  { name: 'Mar', value: 350 },
  { name: 'Apr', value: 400 },
  { name: 'May', value: 500 },
  { name: 'Jun', value: 600 },
  { name: 'Jul', value: 500 },
  { name: 'Aug', value: 300 },
  { name: 'Sep', value: 430 },
  { name: 'Oct', value: 690 },
  { name: 'Nov', value: 500 },
  { name: 'Dec', value: 400 },
];

const marks = data.map((entry, index) => ({ value: index, label: entry.name }));

const Graph = () => {
  const [chartType, setChartType] = useState('line');
  const [selectedDataIndex, setSelectedDataIndex] = useState(data.length / 2);
  const [isPlaying, setIsPlaying] = useState(false);
  const [reverse, setReverse] = useState(false);
  const intervalRef = useRef();

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
        <LineChart
          data={data}
          onMouseMove={(e) => {
            if (e.isTooltipActive) setSelectedDataIndex(e.activeTooltipIndex);
          }}
        >
          <XAxis dataKey='name' />
          <YAxis />
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
          <XAxis dataKey='name' />
          <YAxis />
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
        <ResponsiveContainer width="95%" height={data.length*33}>
        {renderChart()}
        </ResponsiveContainer>
      <div
        style={{
          marginTop: '20px',
          width: '95%',
          marginLeft: '5%',
        }}
      >
        <Slider
          min={0}
          max={data.length - 1}
          marks={marks} //Uncomment to display marks on the slider
          step={1}
          onChange={handleSliderChange}
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
