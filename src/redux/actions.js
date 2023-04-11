export const UPDATE_FLAG = "UPDATE_FLAG";

const updateFlag = (flag, val) => {
  return {
    type: UPDATE_FLAG,
    flag,
    val,
  };
};

export { updateFlag };
