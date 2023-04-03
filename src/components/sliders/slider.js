import './slider.css';

const Slider = ({ props }) => {
  const { header } = props;
  return (
    <div className='sliderContainer'>
      <div className='sliderHeader'>{header}</div>
      <div className='sliderContent'>Put slider here</div>
    </div>
  );
};

export default Slider;
