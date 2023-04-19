import IoIcon from "../SVGS/ioIcon";
import { updateFlag } from "../../redux/actions";
import { useSelector, useDispatch } from "react-redux";

const ButtonSpread = ({ setting }) => {
  const buttonActive = useSelector(
    (state) => state[state.activeState][setting.id]
  );
  const buttonTypeActive = useSelector(
    (state) => state[state.activeState][setting.type]
  );
  const inverseActive = useSelector(
    (state) => state[state.activeState][setting.invId]
  );
  const dispatch = useDispatch();

  const getButtonStyles = () => {
    return {
      borderRadius: "10px",
      width: "100%",
    };
  };

  //Change color of button if (in)active.
  const activeStyle = () => {
    if (isButtonActive()) {
      return {
        backgroundColor: "#C7C7C7",
        boxShadow: "none",
      };
    } else {
      return { backgroundColor: "#D9D9D9", boxShadow: "0px 4px 0px #6A6969" };
    }
  };

  const isButtonActive = () => {
    if (setting.type)
      return Boolean(buttonActive && buttonTypeActive === setting.val);
    return Boolean(buttonActive);
  };

  return (
    <div
      style={{
        display: "flex",
        width: "100%",
        marginLeft: "10px",
        marginRight: "10px",
        justifyContent: "center",
        alignItems: "center",
        flexDirection: "column",
      }}
      onClick={() => {
        if (setting.type) {
          dispatch(updateFlag(setting.type, Number(setting.val)));
        }
        dispatch(updateFlag(setting.id, Number(!buttonActive)));
      }}
    >
      <div
        style={{
          height: 20,
          fontSize: 14,
          fontWeight: "400",
          width: "70%",
        }}
      >
        {setting?.name}
      </div>
      <div
        style={{
          ...getButtonStyles(),
          ...activeStyle(),
          height: 60,
          display: "flex",
          width: "100%",
          flexDirection: "column",
        }}
      >
        <div
          class="mainbutton"
          style={{ borderColor: inverseActive ? "white" : "black" }}
        >
          <div
            class="topBorder"
            style={{ borderColor: inverseActive ? "black" : "white" }}
          ></div>
          <IoIcon
            id="ioicon"
            color={isButtonActive() ? "#00FF00" : "#000000"}
          ></IoIcon>
        </div>
      </div>

      <div
        style={{
          height: 20,
          width: "100%",
        }}
      >
        {Boolean(buttonActive) && setting.invId && (
          <div
            className="mirrorbutton"
            role="button"
            aria-pressed="false"
            onClick={(e) => {
              e.stopPropagation();
              dispatch(updateFlag(setting.invId, Number(!inverseActive)));
            }}
          >
            Inverse
          </div>
        )}
      </div>
    </div>
  );
};

export default ButtonSpread;
