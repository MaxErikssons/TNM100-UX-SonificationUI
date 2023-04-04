import { useState } from 'react';
import IoButton from '../iobutton/ioButton';

const Button = ({ props }) => {
	const { header, settings, background, spread } = props;
	const [buttonClicked, setButtonClicked] = useState(0);

	const getButtonStyles = (index) => {
		if (spread) {
			return {
				...getActiveButton(index + 1),
				borderRadius: '10px',
				height: 70,
				width: '100%',
			};
		}

		const isFirst = index + 1 === 1;
		const isLast = index + 1 === settings.length;

		return {
			...getActiveButton(index + 1),
			borderLeft: !isFirst && 'gray solid 1px',
			borderTopLeftRadius: isFirst && '15px',
			borderBottomLeftRadius: isFirst && '15px',
			borderTopRightRadius: isLast && '15px',
			borderBottomRightRadius: isLast && '15px',
			height: 70,
			width: '100%',
		};
	};

	const getActiveButton = (index) => {
		if (buttonClicked === index) {
			return {
				backgroundColor: '#C7C7C7',
				boxShadow: 'none',
			};
		} else {
			return { backgroundColor: '#D9D9D9', boxShadow: '0px 4px 0px #6A6969' };
		}
	};

	return (
		<div
			style={{
				display: 'flex',
				flexDirection: 'row',
				justifyContent: 'center',
				width: '100%',
			}}
		>
			{settings.map((setting, index) => (
				<div
					key={index}
					style={{
						marginLeft: spread && '10px',
						marginRight: spread && '10px',
						width: '100%',
					}}
				>
					<div>{setting}</div>
					<div
						style={getButtonStyles(index)}
						onClick={() => {
							setButtonClicked(buttonClicked == index + 1 ? 0 : index + 1);
						}}
					>
						<IoButton
							color={buttonClicked == index + 1 ? '#00FF00' : '#000000'}
						></IoButton>
					</div>
				</div>
			))}
		</div>
	);
};

export default Button;
