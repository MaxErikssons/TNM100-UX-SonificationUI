const ButtonContainer = ({
  children,
  title,
  backgroudColor,
  radius = 21,
  flex = 1,
}) => {
  return (
    <div
      style={{
        textAlign: 'center',
        flex,
      }}
    >
      <div style={{ color: 'white', fontWeight: '500', fontSize: 16 }}>
        {title}
      </div>
      <div
        style={{
          backgroundColor: backgroudColor,
          marginLeft: '5%',
          marginRight: '5%',
          marginBottom: '2%',
          borderRadius: radius,
          background: backgroudColor,
          padding: 20,
          boxShadow: `0 1px 1px rgba(0, 0, 0, 0.12), 0 2px 2px rgba(0, 0, 0, 0.12),
        0 4px 4px rgba(0, 0, 0, 0.12), 0 8px 8px rgba(0, 0, 0, 0.12),
        0 16px 16px rgba(0, 0, 0, 0.12)`,
        }}
      >
        {children}
      </div>
    </div>
  );
};

export default ButtonContainer;
