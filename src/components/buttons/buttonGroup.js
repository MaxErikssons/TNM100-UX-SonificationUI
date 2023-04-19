import "./ioButton.css";
import Button from "./button";
import ButtonSpread from "./buttonSpread";

const ButtonGroup = ({ props }) => {
  const { settings, spread } = props;

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "row",
        justifyContent: "center",
        width: "100%",
        height: "100%",
      }}
    >
      {settings.map((setting, index) =>
        spread ? (
          <ButtonSpread setting={setting} />
        ) : (
          <Button
            setting={setting}
            isFirst={index === 0}
            isLast={index === settings.length - 1}
          />
        )
      )}
    </div>
  );
};

export default ButtonGroup;
