import './ioButton.css';
import IoIcon from '../SVGS/ioIcon';
import { useState } from 'react';
import React from 'react';
import _uniqueId from 'lodash/uniqueId';

const IoButton = (props) => {
	//const [color, setColor] = useState('#000000');
	//console.log(props.active);
	//const [active, setActive] = useState(false);
	const [orientation, setOrientation] = useState(false);
	const [id] = useState(_uniqueId('prefix-'));
	console.log(`mainbutton  ${id}`);
	let color = props.color;

	function handleRing(e) {
		e.stopPropagation();
		console.log(e);
		let topRing = document.getElementById(`mainbutton ${id}`);
		let bottomRing = document.getElementById(`topBorder ${id}`);

		setOrientation(orientation ? false : true);

		topRing.style.borderColor = orientation ? 'white' : 'black';
		bottomRing.style.borderColor = orientation ? 'black' : 'white';
	}

	return (
		<div
			style={{
				margin: 'auto',
				display: 'block',
				position: 'relative',
				top: '18%',
				height: '50px',
			}}
		>
			<div class='mainbutton' id={`mainbutton ${id}`}>
				<div class='topBorder' id={`topBorder ${id}`}></div>
				<IoIcon id='ioicon' color={color}></IoIcon>
			</div>
			{color === '#00FF00' && (
				<div
					className='mirrorbutton'
					role='button'
					aria-pressed='false'
					onClick={(e) => handleRing(e)}
				></div>
			)}
		</div>
	);
};

export default IoButton;
