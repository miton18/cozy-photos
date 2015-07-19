// Generated by CoffeeScript 1.9.3
var codes, photoHelpers;

codes = {
  TopLeft: 1,
  TopRight: 2,
  BottomRight: 3,
  BottomLeft: 4,
  LeftTop: 5,
  RightTop: 6,
  RightBottom: 7,
  LeftBottom: 8
};

module.exports = photoHelpers = {
  getOrientation: function(orientation) {
    var result;
    result = 1;
    if (typeof orientation === 'number' && orientation > 0 && orientation < 9) {
      result = orientation;
    } else if (codes[orientation] != null) {
      result = codes[orientation];
    }
    return result;
  }
};
