function ratioValueGetterFormed(params) {
  if (!(params.node && params.node.group)) {
    return createValueObjectFormed(params.data.z, params.data.x);
  }
}
function ratioAggFuncFormed(params) {
  let zSum = 0;
  let xSum = 0;
  params.values.forEach((value) => {
    if (value && value.z) {
      zSum += value.z;
    }
    if (value && value.x) {
      xSum += value.x;
    }
  });
  return createValueObjectFormed(zSum, xSum);
}
function createValueObjectFormed(z, x) {
  return {
    z: z,
    x: x,
    toString: () => `${z && x ? x / z : 0}`,
  };
}
function ratioValueGetterReg(params) {
  if (!(params.node && params.node.group)) {
    return createValueObjectReg(params.data.z, params.data.c);
  }
}
function ratioAggFuncReg(params) {
  let zSum = 0;
  let cSum = 0;
  params.values.forEach((value) => {
    if (value && value.z) {
      zSum += value.z;
    }
    if (value && value.c) {
      cSum += value.c;
    }
  });
  return createValueObjectReg(zSum, cSum);
}
function createValueObjectReg(z, c) {
  return {
    z: z,
    c: c,
    toString: () => `${z && c ? c / z : 0}`,
  };
}
function ratioFormatter(params) {
  if (!params.value || params.value === 0) return '';
  return Math.round(params.value * 100) + `%`;
}