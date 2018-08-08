$(function() {
  var icon = '<i class="fas fa-paste"></i>'
  var codeList = $("pre code")

  $(codeList).each(function( index, elem ) {
    var copy = $("<div/>", { class: "copy", title: "Copy to clipboard"})
    $(copy).html(icon)
    $(copy).click(function() {
      var copyText = $(this).parent().text()
      var temp = $("<input>");
      $("body").append(temp);
      temp.val(copyText).select();
      document.execCommand("copy");
      box.show("Code copied to clipboard")
      $(temp).remove();
    })
    $(elem).parent().prepend(copy)
  });
});


$(function() {
  var icon = '<i class="fas fa-link"></i>'
  var linkList = $("h3")

  $(linkList).each(function( index, elem ) {
    var link = $("<div/>", { class: "link", title: "Copy link to clipboard"})
    var title = $(this).text()
    var title_id = title.replace(/\s/g, "_");

    $(link).html(icon)
    $(link).click(function() {
      var title_id = $(this).parent().attr("id")
      var url = window.location.protocol + "//" +  window.location.host + window.location.pathname + "#" + title_id

      var temp = $("<input>");
      $("body").append(temp);
      temp.val(url).select();
      document.execCommand("copy");
      box.show("Link " + url + " copied to clipboard")
      $(temp).remove();
    });

    var anchor = $("<a/>", { name: title_id }).text(title)
    $(elem).html("")
    $(elem).append(anchor)
    $(elem).append(link)
  });
});
