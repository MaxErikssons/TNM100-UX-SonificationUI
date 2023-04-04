import React, { useState } from 'react';
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
  const [selectedDataIndex, setSelectedDataIndex] = useState(null);

  const handleSliderChange = (value) => {
    setSelectedDataIndex(value);
  };

  const renderChart = () => {
    const selectedData = data[selectedDataIndex];
    if (chartType === 'line') {
      return (
        <LineChart data={data}>
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
        <BarChart data={data}>
          <XAxis dataKey='name' />
          <YAxis />
          <Tooltip />
          <Legend />
          <Bar dataKey='value' fill='#ff7300' />
          {selectedData && (
            <ReferenceLine
              x={selectedData.name}
              strokeDasharray='3 3'
              stroke='black'
            />
          )}
        </BarChart>
      );
    }
  };
  return (
    <div
      style={{
        height: '70%',
        width: '80%',
        marginLeft: '3%',
        marginTop: '4vh',
      }}
    >
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          marginTop: '20px',
        }}
      >
        <button onClick={() => setChartType('line')}>Line Chart</button>
        <button onClick={() => setChartType('bar')}>Bar Chart</button>
      </div>
      <ResponsiveContainer style={{ backgroundColor: 'orange' }}>
        {renderChart()}
      </ResponsiveContainer>
      <div
        style={{
          marginTop: '20px',
          width: '96%',
          marginLeft: '4%',
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
            backgroundColor: 'purple', // Change the color of the rail
          }}
          trackStyle={{
            backgroundColor: 'orange', // Change the color of the track
          }}
          handleStyle={{
            borderColor: 'blue', // Change the color of the circle inside the slider
            backgroundColor: 'white', // Change the background color of the circle inside the slider
          }}
        />
      </div>
    </div>
  );
};

export default Graph;
