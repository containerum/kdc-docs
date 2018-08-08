function AlertBox(item) {
  this.element = item
}

AlertBox.prototype.show = function(text) {
  $(this.element).text(text)
  $(this.element).show()
  return setTimeout( this.hide, 1500, this.element)
}

AlertBox.prototype.hide = function(element) {
  $(element).hide();
};

$(function() {
  box = new AlertBox($("#alert"))
});
