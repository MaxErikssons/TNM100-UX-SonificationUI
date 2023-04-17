export const UPDATE_FLAG = 'UPDATE_FLAG';
export const CHANGE_SETTING = 'CHANGE_SETTING';
export const CHANGE_PROFILE = 'CHANGE_PROFILE';

const updateFlag = (flag, val) => {
  return {
    type: UPDATE_FLAG,
    flag,
    val,
  };
};

const changeSetting = (val) => {
  return {
    type: CHANGE_SETTING,
    val,
  };
};

const changeProfile = (val) => {
  return {
    type: CHANGE_PROFILE,
    val,
  };
};

export { updateFlag, changeSetting, changeProfile };
