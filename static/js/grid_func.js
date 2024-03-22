var dagfuncs = window.dashAgGridFunctions = window.dashAgGridFunctions || {};

dagfuncs.ratioValueGetterSemdFormed = function (params) {
  if (!(params.node && params.node.group)) {
    return createValueObjectSemdFormed(params.data.res_services_success, params.data.res_semd_formed);
  }
}
dagfuncs.ratioAggFuncSemdFormed = function (params) {
  let res_services_successSum = 0;
  let res_semd_formedSum = 0;
  params.values.forEach((value) => {
    if (value && value.res_services_success) {
      res_services_successSum += value.res_services_success;
    }
    if (value && value.res_semd_formed) {
      res_semd_formedSum += value.res_semd_formed;
    }
  });
  return createValueObjectSemdFormed(res_services_successSum, res_semd_formedSum);
}

function createValueObjectSemdFormed(res_services_success, res_semd_formed) {
  return {
    res_services_success: res_services_success,
    res_semd_formed: res_semd_formed,
    toString: () => `${res_services_success && res_semd_formed ? res_semd_formed/ res_services_success : 0}`,
  };
}

dagfuncs.ratioValueGetterSemdReg = function (params) {
  if (!(params.node && params.node.group)) {
    // no need to handle group levels - calculated in the 'ratioAggFunc'
    return createValueObjectSemdReg(params.data.res_services_success, params.data.res_semd_reg);
  }
}
dagfuncs.ratioAggFuncSemdReg = function (params) {
  let res_services_successSum = 0;
  let res_semd_regSum = 0;
  params.values.forEach((value) => {
    if (value && value.res_services_success) {
      res_services_successSum += value.res_services_success;
    }
    if (value && value.res_semd_reg) {
      res_semd_regSum += value.res_semd_reg;
    }
  });
  return createValueObjectSemdReg(res_services_successSum, res_semd_regSum);
}

function createValueObjectSemdReg(res_services_success, res_semd_reg) {
  return {
    res_services_success: res_services_success,
    res_semd_reg: res_semd_reg,
    toString: () => `${res_services_success && res_semd_reg ? res_semd_reg/ res_services_success : 0}`,
  };
}

dagfuncs.ratioFormatter = function (params) {
  if (!params.value || params.value === 0) return '';
  return '' + Math.round(params.value * 100) / 100;
}